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
				input shiftFreeze,
				input validateOut,
				output [7:0] clk_cyc_data);
				
	localparam prior_clk_cyc = 7;
	
	reg [7:0] cntr = 0;
	assign clk_cyc_data = (cntr + prior_clk_cyc);
	
	wire Q;		
	
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (1'b0 or 1'b1)
	) TUBE_LATCH (
		.Q(Q),      				// Data output
		.CLR(clr),  				// Asynchronous clear/reset input
		.D(tubePin),      		// Data input
		.G(~Q),      				// Gate input
		.GE(gateEnable)     		// Gate enable input
	);
	
	
	reg [7:0] shiftReg = 8'h0;
	
	always @ (posedge clk) begin
		if (clr == 1) begin
			shiftReg = 0;
		end else begin 
			if (~shiftFreeze) begin
				shiftReg = shiftReg << 1;
				shiftReg[0] = tubePin;
			end
		end
	end

	
	wire tubeclk = gateEnable && clk;
	reg [3:0] i = 0;

	always @ (posedge tubeclk) begin
		if (clr == 1) begin
			cntr <= 0;
		end else begin 
			if (Q == 0 && cntr < (255-prior_clk_cyc)) begin
				cntr <= cntr + 1;
			end else begin
				if (validateOut == 1) begin
				
					for (i = 0; i < 8; i = i+1) begin
						if (shiftReg[i] == 1) begin
							cntr <= (-i);//(prior_clk_cyc-(i) -prior_clk_cyc);
						end 
					end
					
				end
			end
		end
	end

	
  
					
endmodule
