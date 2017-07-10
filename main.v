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
				 output overflowLight,
				 input SCIN_COIN,
				 input [7:0] TUBE3A,
				 input [7:0] TUBE3B,
				 input [7:0] TUBE4A,
				 input [7:0] TUBE4B,

				 //RPi facing pins
				 output [15:0] OTUBE,
				 input RD_CLK,
				 input RD_EN,
				 output RD_EMPTY,
				 output RD_VALID);

	//the counter that counts on the system 100MHz clock 
	//this is FOR the system
	integer cntr = 0;
	
	integer busyCntr = 0;
	
	reg fifoWrite = 0;
	
	//setting this to high prepares the whole system for another event
	//this will clear all unsaved (not in RAM) data
	reg CLR = 0;
	
	//LDCE:  Transparent latch with Asynchronous Reset and Gate Enable.
	//a latch that will hold high once SCIN_COIN pulses high until CLR'd
	wire SCIN_LATCH_Q;
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (0)
	) SCIN_LATCH (					// Latch name
		.Q(SCIN_LATCH_Q),      	// Data output
		.CLR(CLR),  				// Asynchronous clear/reset input
		.D(SCIN_COIN),      		// Data input
		.G(~SCIN_LATCH_Q),      // Gate input
		.GE(1'b1)     					// Gate enable input
	);
	
	//a 100 MHz clock that is only pulsing when SCIN_LATCH_Q is high
	//ie, only when we are recording an event
	wire tubeclk = SCIN_LATCH_Q && clk100;
	
		//initialize the fifo that will hold all the data before it is sent to the rpi
	//also set up light to turn on when it is full
	reg [15:0] din = 0;
	wire full;
	wire [0:9] wr_data_count;	
	fifo16x1024 fifo( .rst(1'b0),
							.wr_clk(clk100),
							.din(din),
							.wr_en(fifoWrite),
							.full(full),
							.wr_data_count(wr_data_count),
							.rd_clk(RD_CLK),
							.rd_en(RD_EN),
							//.empty(RD_EMPTY),
							.valid(RD_VALID),
							.dout(OTUBE));
	assign overflowLight = full;
							
	assign RD_EMPTY = (wr_data_count == 0);						
	
	//initialize wires and tubes for. every. tube.
	wire [7:0] data3A0;
	wire [7:0] data3A1; 
	wire [7:0] data3A2;
	wire [7:0] data3A3;
	wire [7:0] data3A4;
	wire [7:0] data3A5;
	wire [7:0] data3A6;
	wire [7:0] data3A7;
	wire [7:0] data3B0;
	wire [7:0] data3B1;
	wire [7:0] data3B2;
	wire [7:0] data3B3;
	wire [7:0] data3B4;
	wire [7:0] data3B5;
	wire [7:0] data3B6;
	wire [7:0] data3B7;
	wire [7:0] data4A0;
	wire [7:0] data4A1;
	wire [7:0] data4A2;
	wire [7:0] data4A3;
	wire [7:0] data4A4;
	wire [7:0] data4A5;
	wire [7:0] data4A6;
	wire [7:0] data4A7;
	wire [7:0] data4B0;
	wire [7:0] data4B1;
	wire [7:0] data4B2;
	wire [7:0] data4B3;
	wire [7:0] data4B4;
	wire [7:0] data4B5;
	wire [7:0] data4B6;
	wire [7:0] data4B7;
	
	Tube tube3A0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[0]), .clk_cyc_data(data3A0), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[1]), .clk_cyc_data(data3A1), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[2]), .clk_cyc_data(data3A2), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[3]), .clk_cyc_data(data3A3), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[4]), .clk_cyc_data(data3A4), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[5]), .clk_cyc_data(data3A5), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[6]), .clk_cyc_data(data3A6), .gateEnable(SCIN_LATCH_Q));
	Tube tube3A7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3A[7]), .clk_cyc_data(data3A7), .gateEnable(SCIN_LATCH_Q));

	Tube tube3B0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[0]), .clk_cyc_data(data3B0), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[1]), .clk_cyc_data(data3B1), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[2]), .clk_cyc_data(data3B2), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[3]), .clk_cyc_data(data3B3), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[4]), .clk_cyc_data(data3B4), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[5]), .clk_cyc_data(data3B5), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[6]), .clk_cyc_data(data3B6), .gateEnable(SCIN_LATCH_Q));
	Tube tube3B7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE3B[7]), .clk_cyc_data(data3B7), .gateEnable(SCIN_LATCH_Q));

	Tube tube4A0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[0]), .clk_cyc_data(data4A0), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[1]), .clk_cyc_data(data4A1), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[2]), .clk_cyc_data(data4A2), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[3]), .clk_cyc_data(data4A3), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[4]), .clk_cyc_data(data4A4), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[5]), .clk_cyc_data(data4A5), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[6]), .clk_cyc_data(data4A6), .gateEnable(SCIN_LATCH_Q));
	Tube tube4A7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4A[7]), .clk_cyc_data(data4A7), .gateEnable(SCIN_LATCH_Q));

	Tube tube4B0 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[0]), .clk_cyc_data(data4B0), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B1 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[1]), .clk_cyc_data(data4B1), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B2 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[2]), .clk_cyc_data(data4B2), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B3 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[3]), .clk_cyc_data(data4B3), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B4 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[4]), .clk_cyc_data(data4B4), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B5 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[5]), .clk_cyc_data(data4B5), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B6 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[6]), .clk_cyc_data(data4B6), .gateEnable(SCIN_LATCH_Q));
	Tube tube4B7 (.clk(tubeclk), .clr(CLR), .tubePin(TUBE4B[7]), .clk_cyc_data(data4B7), .gateEnable(SCIN_LATCH_Q));
	
	always @ (negedge clk100) begin
		if (SCIN_COIN) begin
			cntr <= 0;
		end
		if (SCIN_LATCH_Q) begin
			cntr <= cntr + 1;
		end
		
		case(cntr)
			 257:  begin din[15:8] <= data3A0; din[7:0] <= 8'b11000000; fifoWrite <= 1;  end
			 258:  begin din[15:8] <= data3A1; din[7:0] <= 8'b11000100; end
			 259:  begin din[15:8] <= data3A2; din[7:0] <= 8'b11000010; end
			 260:  begin din[15:8] <= data3A3; din[7:0] <= 8'b11000110; end
			 261:  begin din[15:8] <= data3A4; din[7:0] <= 8'b11000001; end
			 262:  begin din[15:8] <= data3A5; din[7:0] <= 8'b11000101; end
			 263:  begin din[15:8] <= data3A6; din[7:0] <= 8'b11000011; end
			 264:  begin din[15:8] <= data3A7; din[7:0] <= 8'b11000111; end
			 265:  begin din[15:8] <= data3B0; din[7:0] <= 8'b11001000; end
			 266:  begin din[15:8] <= data3B1; din[7:0] <= 8'b11001100; end
			 267:  begin din[15:8] <= data3B2; din[7:0] <= 8'b11001010; end
			 268:  begin din[15:8] <= data3B3; din[7:0] <= 8'b11001110; end
			 269:  begin din[15:8] <= data3B4; din[7:0] <= 8'b11001001; end
			 270:  begin din[15:8] <= data3B5; din[7:0] <= 8'b11001101; end
			 271:  begin din[15:8] <= data3B6; din[7:0] <= 8'b11001011; end
			 272:  begin din[15:8] <= data3B7; din[7:0] <= 8'b11001111; end
			 273:  begin din[15:8] <= data4A0; din[7:0] <= 8'b00100000; end
			 274:  begin din[15:8] <= data4A1; din[7:0] <= 8'b00100100; end
			 275:  begin din[15:8] <= data4A2; din[7:0] <= 8'b00100010; end
			 276:  begin din[15:8] <= data4A3; din[7:0] <= 8'b00100110; end
			 277:  begin din[15:8] <= data4A4; din[7:0] <= 8'b00100001; end
			 278:  begin din[15:8] <= data4A5; din[7:0] <= 8'b00100101; end
			 279:  begin din[15:8] <= data4A6; din[7:0] <= 8'b00100011; end
			 280:  begin din[15:8] <= data4A7; din[7:0] <= 8'b00100111; end
			 281:  begin din[15:8] <= data4B0; din[7:0] <= 8'b00101000; end
			 282:  begin din[15:8] <= data4B1; din[7:0] <= 8'b00101100; end
			 283:  begin din[15:8] <= data4B2; din[7:0] <= 8'b00101010; end
			 284:  begin din[15:8] <= data4B3; din[7:0] <= 8'b00101110; end
			 285:  begin din[15:8] <= data4B4; din[7:0] <= 8'b00101001; end
			 286:  begin din[15:8] <= data4B5; din[7:0] <= 8'b00101101; end
			 287:  begin din[15:8] <= data4B6; din[7:0] <= 8'b00101011; end
			 288:  begin din[15:8] <= data4B7; din[7:0] <= 8'b00101111; end
			 289:  begin din <= 16'b1111111111111111;							end
			 290:  begin fifoWrite <= 0;											end
			 default: din <= 16'b1111111111111111;
		endcase
	end
	
	
	//the main loop!
	always @ (posedge clk100) begin
		busyCntr <= busyCntr + 1;

		//time's up for the drift tubes to fire for this scintillator coincidence
		//therefore, record all the clock cycles for all the tubes
		
		if (SCIN_COIN) begin
			busyCntr <= 0;
		end
		
		
		case(busyCntr)
			289: CLR <= 1;
			300: CLR <= 0;
		endcase
	end
	
	
	

endmodule
