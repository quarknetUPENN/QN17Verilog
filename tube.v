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
//a module that controls each tube counter (one for each tube); output is sent to the FIFO
module Tube(input clk,
				input clr,
				input tubePin,
				input gateEnable,
				output [7:0] clk_cyc_data);
				
	localparam prior_clk_cyc = 8 ; //the number of clock cycles we want to look back
	
	reg [7:0] cntr = 0;
	assign clk_cyc_data = cntr; //the output (sent into the FIFO) 
	
	wire Q; //output of LDCE
	reg [7:0] shiftReg = 8'h0; // initializing shift register	
	
	LDCE #(
		.INIT(1'b0) 				// Initial value of latch (1'b0 or 1'b1)
	) TUBE_LATCH (
		.Q(Q),      				// Data output
		.CLR(clr),  				// Asynchronous clear/reset input
		.D(shiftReg[7]),      		// Data input
		.G(~Q),      				// Gate input
		.GE(gateEnable)     		// Gate enable input
	);
	
	
	
	always @ (posedge clk) begin
			shiftReg = shiftReg << 1;
			shiftReg[0] = tubePin;
	end

	
	wire tubeclk = gateEnable && clk; //tubeclk only runs when SCIN_LATCH_Q is high
	
	always @ (posedge tubeclk or posedge clr) begin
		if (clr == 1) begin //if clr is set, reset the counter to 0
			cntr <= 0;
		end else begin 
			// if there has not yet been a coincidence and the counter
			// is less than 255, continue counting
			if (Q == 0 && cntr < (255)) begin 
				cntr <= cntr + 1;				
			end
		end
	end

	
  
					
endmodule
