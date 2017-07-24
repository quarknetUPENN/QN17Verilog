//`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:20 07/06/2017 
// Design Name: 
// Module Name:    main 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies:        
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module main( input clk100,
				 output overflowLight,	//notifies us if the FIFO is full
				 input SCIN_COIN,			//the scintillator coincidence		  
				 input [7:0] TUBE3A,
				 input [7:0] TUBE3B,
				 input [7:0] TUBE4A,
				 input [7:0] TUBE4B,

				 //RPi facing pins
				 output [15:0] OTUBE,	//gives the tube name and time in clk cycles
				 input RD_CLK,
				 input RD_EN,
				 output RD_EMPTY,
				 output RD_VALID);

	 // slows clk100 (100MHz) to clk50 (50 MHz), needed in order to meet timing constraints
    wire clk100_fb;
    wire clk50;
    DCM_SP #(.CLKIN_PERIOD(10.0), .CLKDV_DIVIDE(2),
	     .CLK_FEEDBACK("2X"))
    dcm_clk100 (.RST(1'b0), .CLKIN(clk100), .CLKDV(clk50),
		.CLK2X(clk100_fb), .CLKFB(clk100_fb));
		
		

	wire fifo_rd_en;
	
	reg [7:0] rd_en_cntr = 0;
	reg [7:0] dup = 0;
	
	reg [15:0] oldOTUBE = 16'b1111111111111111;

	wire rd_clk_1;
	wire rd_clk_2;

	FDCE #(
		.INIT(1'b0) 				// Initial value of latch (0)
	) RD_CLK_DELAY_1 (					// Latch name
		.Q(rd_clk_1),      	// Data output
		.CLR(1'b0),  				// Asynchronous clear/reset input
		.D(RD_CLK),      			// Data input
		.C(~clk50),      			// Gate input
		.CE(1'b1)     				// Gate enable input
	);
	
	FDCE #(
		.INIT(1'b0) 				// Initial value of latch (0)
	) RD_CLK_DELAY_2 (					// Latch name
		.Q(rd_clk_2),      	// Data output
		.CLR(1'b0),  				// Asynchronous clear/reset input
		.D(rd_clk_1),      			// Data input
		.C(~clk50),      			// Gate input
		.CE(1'b1)     				// Gate enable input
	);
	
	
	//wire rd_clk_edge;
	assign fifo_rd_en = (!rd_clk_2) && rd_clk_1 && RD_EN;
	
	always @ (posedge fifo_rd_en) begin
		rd_en_cntr <= rd_en_cntr + 1;
		
		if(oldOTUBE == OTUBE) begin
			dup <= dup + 1;
		end
		
		oldOTUBE <= OTUBE;
	end
	

	//two counters that count with the sys 100MHz clock, counting up from the falling edge of SCIN_COIN
	//cntr will freeze when SCIN_LATCH_Q drops low, aka when CLR goes high
	integer cntr = 0;
	//busyCntr will always be counting up, regardless of everything else
	integer busyCntr = 0;
	
	//setting this to high prepares the whole system for another event
	//this will clear all unsaved (not in FIFO) data
	reg CLR = 0;
	
	//LDCE:  Transparent latch with Asynchronous Reset and Gate Enable.
	//a latch that will hold high once SCIN_COIN pulses high until CLR'd
	wire SCIN_LATCH_Q;
	wire bufQ;
	//BUFG: clock buffer, allows us to feed Q back into the LDCE as the gate
   BUFG BUFG_inst (
      .O(bufQ),     // Clock buffer output
      .I(SCIN_LATCH_Q)      // Clock buffer input
   );
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (0)
	) SCIN_LATCH (					// Latch name
		.Q(SCIN_LATCH_Q),      	// Data output
		.CLR(CLR),  				// Asynchronous clear/reset input
		.D(SCIN_COIN),      		// Data input
		.G(~bufQ),      			// Gate input
		.GE(1'b1)     				// Gate enable input
	);
	
	wire fifo_valid;
	
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (0)
	) VALID_LATCH (					// Latch name
		.Q(RD_VALID),      	// Data output
		.CLR(fifo_rd_en),  				// Asynchronous clear/reset input
		.D(fifo_valid),      		// Data input
		.G(~RD_VALID),      			// Gate input
		.GE(1'b1)     				// Gate enable input
	);
	
						
	//a 100 MHz clock that is only pulsing when SCIN_LATCH_Q is high
	//ie, only when we are recording an event
	wire tubeclk = clk100;
	
	//initialize the fifo that will hold all the data before it is sent to the rpi
	//also set up light to turn on when it is full
	reg [15:0] din = 0;
	wire full;
	wire [9:0] wr_data_count;
	reg wr_en = 0;
	fifo16x1024 fifo( .rst(1'b0),
							.wr_clk(clk50),
							.din(din),
							.wr_en(wr_en),
							.full(full),
							.wr_data_count(wr_data_count),
							.rd_clk(clk50),
							.rd_en(fifo_rd_en),
							.empty(RD_EMPTY),  //for some reason, this doesn't seem to work as it should - as in, random uS-scale delays for no reason?
							.valid(fifo_valid),
							.dout(OTUBE));
	assign overflowLight = full;
							
	
	//initialize wires and tubes for. every. tube.
	wire [7:0] data3A0;  Tube tube3A0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[0]), .clk_cyc_data(data3A0), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A1;  Tube tube3A1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[1]), .clk_cyc_data(data3A1), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A2;  Tube tube3A2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[2]), .clk_cyc_data(data3A2), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A3;  Tube tube3A3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[3]), .clk_cyc_data(data3A3), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A4;  Tube tube3A4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[4]), .clk_cyc_data(data3A4), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A5;  Tube tube3A5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[5]), .clk_cyc_data(data3A5), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A6;  Tube tube3A6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[6]), .clk_cyc_data(data3A6), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3A7;  Tube tube3A7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[7]), .clk_cyc_data(data3A7), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B0;  Tube tube3B0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[0]), .clk_cyc_data(data3B0), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B1;  Tube tube3B1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[1]), .clk_cyc_data(data3B1), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B2;  Tube tube3B2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[2]), .clk_cyc_data(data3B2), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B3;  Tube tube3B3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[3]), .clk_cyc_data(data3B3), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B4;  Tube tube3B4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[4]), .clk_cyc_data(data3B4), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B5;  Tube tube3B5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[5]), .clk_cyc_data(data3B5), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B6;  Tube tube3B6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[6]), .clk_cyc_data(data3B6), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data3B7;  Tube tube3B7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[7]), .clk_cyc_data(data3B7), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A0;  Tube tube4A0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[0]), .clk_cyc_data(data4A0), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A1;  Tube tube4A1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[1]), .clk_cyc_data(data4A1), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A2;  Tube tube4A2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[2]), .clk_cyc_data(data4A2), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A3;  Tube tube4A3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[3]), .clk_cyc_data(data4A3), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A4;  Tube tube4A4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[4]), .clk_cyc_data(data4A4), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A5;  Tube tube4A5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[5]), .clk_cyc_data(data4A5), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A6;  Tube tube4A6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[6]), .clk_cyc_data(data4A6), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4A7;  Tube tube4A7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[7]), .clk_cyc_data(data4A7), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B0;  Tube tube4B0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[0]), .clk_cyc_data(data4B0), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B1;  Tube tube4B1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[1]), .clk_cyc_data(data4B1), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B2;  Tube tube4B2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[2]), .clk_cyc_data(data4B2), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B3;  Tube tube4B3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[3]), .clk_cyc_data(data4B3), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B4;  Tube tube4B4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[4]), .clk_cyc_data(data4B4), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B5;  Tube tube4B5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[5]), .clk_cyc_data(data4B5), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B6;  Tube tube4B6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[6]), .clk_cyc_data(data4B6), .gateEnable(SCIN_LATCH_Q));
	wire [7:0] data4B7;  Tube tube4B7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[7]), .clk_cyc_data(data4B7), .gateEnable(SCIN_LATCH_Q));	
	
	// set up the reading output protocol
	//assign RD_EMPTY = (wr_data_count == 0); //wr_data_count gives the amount of data in the FIFO						


	always @ (negedge clk50) begin
		if (SCIN_COIN) begin
			cntr <= 0; //once we get a coincidence, reset the counter to 0
		end else begin
			if (SCIN_LATCH_Q) begin 
				cntr <= cntr + 1; //keep counting as long as SCIN_LATCH_Q is high
			end
		end
		
		//din[15:8] == tube time; din [7:0] = tube name
		//refer to FPGA Layout for more info on the tube name
		case(cntr)
			 257:  begin din[15:8] <= data3A0; din[7:0] <= 8'b00000011; wr_en <= 1;  end
			 258:  begin din[15:8] <= data3A1; din[7:0] <= 8'b00100011; end
			 259:  begin din[15:8] <= data3A2; din[7:0] <= 8'b01000011; end
			 260:  begin din[15:8] <= data3A3; din[7:0] <= 8'b01100011; end
			 261:  begin din[15:8] <= data3A4; din[7:0] <= 8'b10000011; end
			 262:  begin din[15:8] <= data3A5; din[7:0] <= 8'b10100011; end
			 263:  begin din[15:8] <= data3A6; din[7:0] <= 8'b11000011; end
			 264:  begin din[15:8] <= data3A7; din[7:0] <= 8'b11100011; end
			 265:  begin din[15:8] <= data3B0; din[7:0] <= 8'b00010011; end
			 266:  begin din[15:8] <= data3B1; din[7:0] <= 8'b00110011; end
			 267:  begin din[15:8] <= data3B2; din[7:0] <= 8'b01010011; end
			 268:  begin din[15:8] <= data3B3; din[7:0] <= 8'b01110011; end
			 269:  begin din[15:8] <= data3B4; din[7:0] <= 8'b10010011; end
			 270:  begin din[15:8] <= data3B5; din[7:0] <= 8'b10110011; end
			 271:  begin din[15:8] <= data3B6; din[7:0] <= 8'b11010011; end
			 272:  begin din[15:8] <= data3B7; din[7:0] <= 8'b11110011; end
			 273:  begin din[15:8] <= data4A0; din[7:0] <= 8'b00000100; end
			 274:  begin din[15:8] <= data4A1; din[7:0] <= 8'b00100100; end
			 275:  begin din[15:8] <= data4A2; din[7:0] <= 8'b01000100; end
			 276:  begin din[15:8] <= data4A3; din[7:0] <= 8'b01100100; end
			 277:  begin din[15:8] <= data4A4; din[7:0] <= 8'b10000100; end
			 278:  begin din[15:8] <= data4A5; din[7:0] <= 8'b10100100; end
			 279:  begin din[15:8] <= data4A6; din[7:0] <= 8'b11000100; end
			 280:  begin din[15:8] <= data4A7; din[7:0] <= 8'b11100100; end
			 281:  begin din[15:8] <= data4B0; din[7:0] <= 8'b00010100; end
			 282:  begin din[15:8] <= data4B1; din[7:0] <= 8'b00110100; end
			 283:  begin din[15:8] <= data4B2; din[7:0] <= 8'b01010100; end
			 284:  begin din[15:8] <= data4B3; din[7:0] <= 8'b01110100; end
			 285:  begin din[15:8] <= data4B4; din[7:0] <= 8'b10010100; end
			 286:  begin din[15:8] <= data4B5; din[7:0] <= 8'b10110100; end
			 287:  begin din[15:8] <= data4B6; din[7:0] <= 8'b11010100; end
			 288:  begin din[15:8] <= data4B7; din[7:0] <= 8'b11110100; end
			 289:  begin din <= 16'b1111111111111111;							end
			 290:  begin wr_en <= 0;												end
			 default: din <= 16'b1111111111111111;
		endcase
	end
	
	 
	//reg [9:0] mycounter = 0;

	//deal with the clear logic, which is independant of the r/w logic for the tubes
	//cntr control the writing until 290, and is then reset; busyCntr is in line with counter
	//until counter is reset, busyCntr's only purpose is to control CLR
	always @ (posedge clk50) begin
		busyCntr <= busyCntr + 1; //
		if (SCIN_COIN) begin
			busyCntr <= 0;
		end
		
		case(busyCntr)
			289: begin CLR <= 1; end //busyCntr pulses CLR
			300: CLR <= 0;
		endcase
		
		//mycounter <= mycounter + 1; 
	end
	

////	 
//	  //configure ChipScope 
//	 wire [35:0] ila_control;
//    wire [63:0] ila_trig0;
//    chipscope_ila ila(.CONTROL(ila_control), 
//							 .CLK(clk100), 
//							 .TRIG0(ila_trig0));
//    chipscope_icon icon(.CONTROL0(ila_control));
//    assign ila_trig0[7:0] = TUBE3A;
//	 assign ila_trig0[15:8] = TUBE3B;
//	 assign ila_trig0[23:16] = TUBE4A;
//	 assign ila_trig0[31:24] = TUBE4B; 
//	 assign ila_trig0[32] = validateOut;
//	 assign ila_trig0[40:33] = data4B0;
//	 assign ila_trig0[48:41] = shift4B0;
//	 assign ila_trig0[50] = shiftFreeze;
//	 assign ila_trig0[51] = CLR;
//
//	 
////	 assign ila_trig0 [48] = RD_EMPTY;
//	 assign ila_trig0 [49] = RD_VALID;
////	 assign ila_trig0 [50] = RD_CLK;
////	 assign ila_trig0[51] = RD_EN; 
//	 assign ila_trig0[54] = SCIN_COIN;
//	 assign ila_trig0[52] = SCIN_LATCH_Q;
//	 assign ila_trig0[53] = clk50;
//	 assign ila_trig0[63:55]= mycounter; 

	 //configure ChipScope 
	 wire [35:0] ila_control;
    wire [63:0] ila_trig0;
    chipscope_ila ila(.CONTROL(ila_control), 
							 .CLK(clk100), 
							 .TRIG0(ila_trig0));
    chipscope_icon icon(.CONTROL0(ila_control));
	 assign ila_trig0[31:0] = cntr;
	 assign ila_trig0[32] = SCIN_COIN;
	 
	 assign ila_trig0[33] = RD_EMPTY;
	 assign ila_trig0[34] = RD_VALID;
	 assign ila_trig0[35] = RD_CLK;
	 assign ila_trig0[51:36] = OTUBE;
	 assign ila_trig0[61:52] = wr_data_count;
	 assign ila_trig0[62] = clk50;
	 assign ila_trig0[63] = fifo_rd_en;
 

endmodule
