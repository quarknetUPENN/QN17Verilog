`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:49 07/06/2017 
// Design Name: 
// Module Name:    tube 
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
module Tube(input clk,
				input clr,
				input tubePin,
				input gateEnable,
				input [7:0] tubeCntr,
				output [7:0] clk_cyc_data);
	
	reg [7:0] cntr = 0;
	assign clk_cyc_data = cntr;
	
	wire Q;
//	wire SCIN_LOCK;
//	
//	FDCE #(
//		.INIT(1'b0)
//	) LATCH1 (
//		.Q(Q),
//		.CLR(clr),
//		.D(1'b1),
//		.C(tubePin & ~SCIN_LOCK),
//		.CE(gateEnable)
//	);
//	FDCE #(
//		.INIT(1'b0)
//	) LATCH2 (
//		.Q(SCIN_LOCK),
//		.CLR(clr),
//		.D(1'b1),
//		.C(Q),
//		.CE(gateEnable)
//	);
		
	
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (1'b0 or 1'b1)
	) TUBE_LATCH (
		.Q(Q),      				// Data output
		.CLR(clr),  				// Asynchronous clear/reset input
		.D(tubePin),      		// Data input
		.G(~Q),      				// Gate input
		.GE(gateEnable)     		// Gate enable input
	);

	

	always @ (posedge clk) begin
		if (Q == 0) begin
			cntr <= tubeCntr;
		end
	end
	
  
					
endmodule
