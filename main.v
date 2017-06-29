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
		input SCIN_COIN,
		input [0:7] TUBE3A,
		input [0:7] TUBE3B,
		input [0:7] TUBE4A,
		input [0:7] TUBE4B,
		
		//RPi facing pins
		output [0:7] OTUBEX,
		output [0:7] OTUBEY,
		input RD_CLK,
		input RD_EN,
		output RD_EMPTY,
		output RD_VALID
		);

endmodule
