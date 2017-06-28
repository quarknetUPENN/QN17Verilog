`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:36:42 06/27/2017 
// Design Name: 
// Module Name:    counter_8 
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
module counter_8(
    input clk100,
    output DATAREADY,
    output [7:0] LED
    );
	 
integer sysclkDiv = 0;
integer clkDiv = 0;
reg sysclk = 0;
reg slowclk = 0;
reg [7:0]Cntr =0;

assign LED = Cntr;
assign DATAREADY = slowclk;	

wire RST = 0;
wire WR_EN = 1;

wire FULL,WR_ACK;
wire [6:0]WR_DATA_COUNT;

wire [15:0]DOUT;

wire RD_EN = 1;
wire EMPTY,VALID;
wire [6:0]RD_DATA_COUNT;

wire [15:0]DIN;
reg [15:0]din1 = 1;
assign DIN = din1;

 

fifo128x16 fifo(.rst(RST),
		.wr_clk(slowclk),
		.din(DIN),
		.wr_en(WR_EN),
		.full(FULL),
		.wr_ack(WR_ACK),
		.wr_data_count(WR_DATA_COUNT),
		
		.rd_clk(slowclk),
		.dout(DOUT),
		.rd_en(RD_EN),
		.empty(EMPTY),
		.valid(VALID),
		.rd_data_count(RD_DATA_COUNT));
		


// Two stage clk divider
always @(posedge clk100)begin
			sysclkDiv = sysclkDiv + 1;
				if(sysclkDiv == 5000)begin
					sysclk <= ~sysclk;
					sysclkDiv = 0;
				end	
	   end
always @(posedge sysclk)begin
			clkDiv = clkDiv + 1;
				if(clkDiv == 500)begin 
					slowclk <= ~slowclk;
					clkDiv = 0;
				end	
				
			Cntr <= DOUT;
	   end	
always @(negedge sysclk)begin
		din1 = Cntr + 1;
	end




endmodule
