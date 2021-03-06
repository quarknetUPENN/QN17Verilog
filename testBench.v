`timescale 1ns / 1ps
`default_nettype none
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:22:13 07/07/2017
// Design Name:   main
// Module Name:   C:/Users/HEP/Documents/Quarknet 2017/QN17Verilog/testBench.v
// Project Name:  QN17Verilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testBench; 

	// Inputs
	reg clk100;
	reg SCIN_COIN;
	reg [7:0] TUBE3A;
	reg [7:0] TUBE3B;
	reg [7:0] TUBE4A;
	reg [7:0] TUBE4B;
	reg RD_CLK;
	reg RD_EN;

	// Outputs
	wire overflowLight;
	wire [15:0] OTUBE;
	wire RD_EMPTY;
	wire RD_VALID;

	// Instantiate the Unit Under Test (UUT)
	main uut (
		.clk100(clk100), 
		.overflowLight(overflowLight), 
		.SCIN_COIN(SCIN_COIN), 
		.TUBE3A(TUBE3A), 
		.TUBE3B(TUBE3B), 
		.TUBE4A(TUBE4A), 
		.TUBE4B(TUBE4B), 
		.OTUBE(OTUBE), 
		.RD_CLK(RD_CLK), 
		.RD_EN(RD_EN), 
		.RD_EMPTY(RD_EMPTY), 
		.RD_VALID(RD_VALID)
	);

	initial begin
		// Initialize Inputs
		clk100 = 0;
		SCIN_COIN = 0;
		TUBE3A = 0;
		TUBE3B = 0;
		TUBE4A = 0;
		TUBE4B = 0;
		RD_CLK = 0;
		RD_EN = 1;


		// Wait 100 ns for global reset to finish
		#100;
		
		SCIN_COIN = 1;
		#60
		SCIN_COIN = 0;

		#60
		TUBE3A[0] = 1'b1;
		#40
		TUBE3A[0] = 1'b0;
		
		#9990
		RD_CLK = 1;
		#10000
		RD_CLK = 0;
		
	
	end
	
	
	//sim the clock
	localparam CLOCK_PERIOD = 10.0;
	initial begin
		while (1) begin
			clk100 = 0;
			# (CLOCK_PERIOD/2);
			clk100 = 1;
			# (CLOCK_PERIOD/2);
		end
	end 
	

	
	initial begin
		# 100000;
		$finish();
	end
      
endmodule

