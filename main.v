`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:03 06/28/2017 
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
module main(
		input clk100,
		output overflowLight,
		input SCIN_COIN,
		input [0:7] TUBE3A,
		input [0:7] TUBE3B,
		input [0:7] TUBE4A,
		input [0:7] TUBE4B,

		
		//RPi facing pins
		output [0:7] OTUBEN,
		output [0:7] OTUBER,
		input RD_CLK1,
		input RD_EN1,
		output RD_EMPTY,
		output RD_VALID);
	
		
// a reg holding all the data from every tube sequentially
reg [0:255] tuberad = 'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
// the counter that provides timing information for each tube
reg [0:7] cntr;

// SET UP ififo
reg ififo_rst = 0;
reg ififo_wr_clk = 0;
reg ififo_wr_en = 1;
wire ififo_full = 0;
reg ififo_rd_clk = 0;
reg ififo_rd_en = 1;
wire ififo_empty;
wire [0:255] ififo_dout;
fif64x256 ififo(.rst(ififo_rst),
						.wr_clk(ififo_wr_clk),
						.din(tuberad),
						.wr_en(ififo_wr_en),
						.full(ififo_full),
						.rd_clk(ififo_rd_clk),
						.dout(ififo_dout),
						.rd_en(ififo_rd_en),
						.empty(ififo_empty));


// SET UP ofifo
reg ofifo_rst = 0;
reg ofifo_wr_en = 1;
wire ofifo_rd_en = 1;
reg ofifo_wr_clk = 0;
reg [0:15] ofifo_din;
wire ofifo_full = 0;
wire ofifo_rd_clk = 0;
wire [0:15] ofifo_dout;
wire ofifo_empty;
wire ofifo_valid;
wire [0:6] ofifo_wr_data_count = 0;
wire buffer_ofifo_clock;
BUFG BUFG_inst (
	.O(buffer_ofifo_clock),     // Clock buffer output
	.I(RD_CLK1)      				 // Clock buffer input
);
fif64x16 ofifo(.rst(ofifo_rst),
					.wr_clk(ofifo_wr_clk),
					.din(ofifo_din),
					.wr_en(ofifo_wr_en),
					.full(ofifo_full),
					.rd_clk(buffered_ofifo_clock),
					.dout(ofifo_dout),
					.rd_en(RD_EN1),
					.empty(ofifo_empty),
					.valid(ofifo_valid),
					.wr_data_count(ofifo_wr_data_count));



// if the internal fifo is full, show it
assign overflowLight = ififo_full;

// make the output ofifo control pins work
assign RD_VALID = ofifo_valid;
assign RD_EMPTY = ofifo_empty;



integer i;
integer j;

//if there is a value to be sent to the rpi from the ififo, move it to the ofifo
always @ (posedge ofifo_empty) begin
	//don't move data if there be no data
	//what am a break statement
	if (!ififo_empty) begin
		//Get top value from ififo
		ififo_rd_clk = 1;
		#30 ififo_rd_clk = 0;
		
		//parse top value from ififo
		for (i = 0; i < 32; i = i +1) begin
			j = 8*i+7; //the ending bit
			
			//fills in [0:3] based on the level number [3,4]
			//fills in 4 based on the sublevel letter A,B -> 0,1
			if (j < 64) begin
				ofifo_din[0:4] = 'b1100;
			end else if (j < 128) begin
				ofifo_din[0:4] = 'b1101;
			end else if (j < 192) begin
				ofifo_din[0:4] = 'b0010;
			end else if (j < 256) begin
				ofifo_din[0:4] = 'b0011;
			end else begin
				ofifo_din[0:4] = 'b1111;
			end
			//fills in [5:7] as the tube number [0,7]
			ofifo_din[5:7] = i % 7;
			
			//fills in [8:15] as the tube radius from the event stored in the ififo
			ofifo_din[8:15] = ififo_dout[j-7+:8];  
			
			//sends ofifo_din into the ofifo
			ofifo_wr_clk = 1;
			#30 ofifo_wr_clk = 0;
		end
	end
end




always @ (posedge clk100) begin
	cntr <= cntr + 1;
end

always @ (posedge SCIN_COIN) begin
	cntr = 0;
	#320 ififo_wr_clk = 1;
	#30 ififo_wr_clk = 0;
	tuberad <= 'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
end

always @ (posedge TUBE3A[0]) begin
	tuberad[0:7] = cntr; 
end

always @ (posedge TUBE3A[1]) begin
	tuberad[8:15] = cntr;
end

always @ (posedge TUBE3A[2]) begin
	tuberad[16:23] = cntr;
end

always @ (posedge TUBE3A[3]) begin
	tuberad[24:31] = cntr;
end

always @ (posedge TUBE3A[4]) begin
	tuberad[32:39] = cntr;
end

always @ (posedge TUBE3A[5]) begin
	tuberad[40:47] = cntr;
end

always @ (posedge TUBE3A[6]) begin
	tuberad[48:55] = cntr;
end

always @ (posedge TUBE3A[7]) begin
	tuberad[56:63] = cntr;
end


always @ (posedge TUBE3B[0]) begin
	tuberad[64:71] = cntr;
end

always @ (posedge TUBE3B[1]) begin
	tuberad[72:79] = cntr;
end

always @ (posedge TUBE3B[2]) begin
	tuberad[80:87] = cntr;
end

always @ (posedge TUBE3B[3]) begin
	tuberad[88:95] = cntr;
end

always @ (posedge TUBE3B[4]) begin
	tuberad[96:103] = cntr;
end

always @ (posedge TUBE3B[5]) begin
	tuberad[104:111] = cntr;
end

always @ (posedge TUBE3B[6]) begin
	tuberad[112:119] = cntr;
end

always @ (posedge TUBE3B[7]) begin
	tuberad[120:127] = cntr;
end



always @ (posedge TUBE4A[0]) begin
	tuberad[128:135] = cntr;
end

always @ (posedge TUBE4A[1]) begin
	tuberad[136:143] = cntr;
end

always @ (posedge TUBE4A[2]) begin
	tuberad[144:151] = cntr;
end

always @ (posedge TUBE4A[3]) begin
	tuberad[152:159] = cntr;
end

always @ (posedge TUBE4A[4]) begin
	tuberad[160:167] = cntr;
end

always @ (posedge TUBE4A[5]) begin
	tuberad[168:175] = cntr;
end

always @ (posedge TUBE4A[6]) begin
	tuberad[176:183] = cntr;
end

always @ (posedge TUBE4A[7]) begin
	tuberad[184:191] = cntr;
end



always @ (posedge TUBE4B[0]) begin
	tuberad[192:199] = cntr;
end

always @ (posedge TUBE4B[1]) begin
	tuberad[200:207] = cntr;
end

always @ (posedge TUBE4B[2]) begin
	tuberad[208:215] = cntr;
end

always @ (posedge TUBE4B[3]) begin
	tuberad[216:223] = cntr;
end

always @ (posedge TUBE4B[4]) begin
	tuberad[224:231] = cntr;
end

always @ (posedge TUBE4B[5]) begin
	tuberad[232:239] = cntr;
end

always @ (posedge TUBE4B[6]) begin
	tuberad[240:247] = cntr;
end

always @ (posedge TUBE4B[7]) begin
	tuberad[248:255] = cntr;
end		

endmodule 