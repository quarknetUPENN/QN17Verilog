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
		input SCIN_COIN,
		input [0:7] TUBE3A,
		input [0:7] TUBE3B,
		input [0:7] TUBE4A,
		input [0:7] TUBE4B,
		
		//RPi facing pins
		output [0:7] OTUBEN,
		output [0:7] OTUBER,
		input RD_CLK,
		input RD_EN,
		output RD_EMPTY,
		output RD_VALID);

parameter clockcntrmax = 100

reg tuberad [0:255]= {256{1'b1}}
reg [0:7] cntr

always @ (posedge clk100) begin
		cntr <=cntr + 1;
end

always @ (posedge SCIN_COIN) begin
		cntr = 0;
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