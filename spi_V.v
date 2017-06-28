`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:38:50 06/25/2012 
// Design Name: 
// Module Name:    spi 
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
module spi #( parameter BASE_ADDR = 16'h2000, SPI_EDGE = 1'b1, MODE = 1'b1, integer ClkDiv = 0  /*DataSize = 8*/)
	(
    input wire  clk,
	 input wire	 sclk_i,
	 input wire [1+1+16+16-1:0] ibus,
    input wire  miso,
	 input wire  rst,
	 output wire sclk_o,
	 output wire cs,
    output wire mosi,
	 output wire [15:0] SpiDataOut,
	 output wire[15:0] Spi_Status,
	 output reg [31:0]SpiDataReg
    );

	integer ClkDivcntr = 0;
	integer sysclkDiv = 0;
	reg modsclk = 0; //(SPI_EDGE)? 1:0;
	reg sysclk = 0;
	integer clkDiv2 = 0;
	reg Delay = 0;
	reg Disable = 0;
	
	always @(posedge clk)begin
			sysclkDiv = sysclkDiv + 1;
				if(sysclkDiv == ClkDiv)begin //&& cs==0 
					sysclk <= ~sysclk;
					sysclkDiv = 0;
				end	
	   end
		
		always @(negedge clk)begin
			//if(valid_data1)begin
				ClkDivcntr = ClkDivcntr + 1;
				if(ClkDivcntr == ClkDiv)begin //&& cs==0 
					modsclk <= ~modsclk;
					ClkDivcntr = 0;
				end	
			//end
	   end
///////////////PARAMETERS//////////////////////////

parameter   Din   			 =  1'b1;
parameter   CE    			 =  1'b1;
parameter   ON  			    =  1'b1;
parameter   OFF    			 =  1'b0;
parameter   PRE   		    =  1'b0;

////////////////////////////DECLARATIONS//////////////////////////////////////////////////
	reg [4:0]  fsm = 0;
	reg [4:0]  fsm_d = 0;
	integer i = 0;
	integer t = 0;	
	wire valid_data1, valid_data2, sclk_p;
	wire ififo_empty;
	reg  Enable_Vdata2 = 0; // Disable = 0;
	wire [15:0] ofifo_data_o, ififo_data_o;  //ififo_data_i,
	reg [15:0]ofifo_data_i = 0;
	//reg [31:0]SpiDataReg = 32'h001FFAA8;
	reg [31:0]SpiDataBuff = 32'h001FFAAD;

	wire ofifo_empty;
	
	reg ofifo_rd_en = 0;
	reg ofifo_wr_en = 0;
	reg ififo_rd_en = 0;
	reg ififo_wr_en = 0;
	
	reg clr_Vdata  = 0;
	reg [3:0]sclk_count = 0;
	reg movData = 0;
	reg mosi_o = 0;
	reg cs_o = 1;
	
	reg start_en = 0;
	reg TxDone = 0;
		
//////////////////////INSTANTIATIONS/////////////////////
localparam
SPI_CTRL			= BASE_ADDR + 16'h0000,
DATA_OUT_REG	= BASE_ADDR + 16'h0000,
DATASIZE_REG 	= BASE_ADDR + 16'h0001,
DATA_IN_REG		= BASE_ADDR + 16'h0002,
SPI_STATUS_REG	= BASE_ADDR + 16'h0003,

SPI_WRITE 	= 16'h1,
SPI_READ 	= 16'h2,
SPI_START 	= 16'h3,
CLEAR_CMD 	= 16'h4,
RST_CMD 		= 16'h5;



wire Clk, bwr;
wire [15:0]DataSize, baddr, bwrdata, ififo_data_i, command;
wire [5:0]data_count_i;
assign {Clk, bwr, baddr, bwrdata} = ibus;
//integer SetDataSize = 2;
reg  clrw_ack = 0;
busreg #(SPI_CTRL) SpiControl(.clk(Clk),.wr(bwr), .wraddr(baddr),.wrdata(bwrdata),.regdat(command));
busreg #(DATASIZE_REG) Dsize(.clk(Clk), .wr(bwr), .wraddr(baddr), .wrdata(bwrdata), .regdat(DataSize));
busreg #(DATA_IN_REG) Data_i(.clk(Clk), .wr(bwr), .wraddr(baddr), .wrdata(bwrdata), .regdat(ififo_data_i));
bror #(DATA_OUT_REG) Data_o(ibus, SpiDataOut, ofifo_data_o); // DATA OUT from SPI	
bror #(SPI_STATUS_REG) SpiStatus(ibus, SpiDataOut, Spi_Status);		
	


fifo16x16 ififo(
		.clk(clk),
		.rst(rst),
		.din(ififo_data_i),
		.wr_en(ififo_wr_en),
		.rd_en(ififo_rd_en),
		.dout(ififo_data_o),
		.full(ififo_full),
		.wr_ack(wr_ack),
		.empty(ififo_empty),
		.valid(ififo_valid),
		.data_count(data_count_i)
 );


fifo16x16 ofifo(
		.clk(clk),
		.rst(rst),
		.din(ofifo_data_i),
		.wr_en(ofifo_wr_en),
		.rd_en(ofifo_rd_en),
		.dout(ofifo_data_o),
		.full(ofifo_full),
		//.wr_ack(wr_ack),
		.empty(ofifo_empty),
		.valid(ofifo_valid)
 );
 
  FDCPE  #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDCPE_VData1 (
      .Q(valid_data1),      // Data output
      .C(ififo_valid),   // Clock input
      .CE(CE),    // Clock enable input
      .CLR(clr_Vdata || rst),  // Asynchronous clear input
      .D(Din),      // Data input
      .PRE(PRE)   // Asynchronous set input  Enable_Vdata2
   );

	
  FDCPE  #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDCPE_VData2 (
      .Q(valid_data2),      // Data output
      .C(ififo_valid && Enable_Vdata2),   // Clock input
      .CE(CE),    // Clock enable input
      .CLR(clr_Vdata || rst),  // Asynchronous clear input
      .D(Din),      // Data input
      .PRE(PRE)   // Asynchronous set input  Enable_Vdata2
   );
	FDCPE  #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDCPE_spictrl (
      .Q(Enable),      // Data output
      .C((baddr == SPI_CTRL) &&  bwr ),   // Clock input
      .CE(CE),    // Clock enable input
      .CLR(Disable || rst),  // Asynchronous clear input
      .D(Din),      // Data input
      .PRE(PRE)   // Asynchronous set input
   );

	FDCPE  #(
      .INIT(1'b0) // Initial value of register (1'b0 or 1'b1)
   ) FDCPE_wr_ack (
      .Q(w_ack),      // Data output
      .C(wr_ack),   // Clock input
      .CE(CE),    // Clock enable input
      .CLR(clrw_ack || rst),  // Asynchronous clear input
      .D(Din),      // Data input
      .PRE(PRE)   // Asynchronous set input
   );
	
//////////////////////////////////////////////////////////////////////	
	
	reg [5:0]Spi_fsm = 0;
	reg [5:0]Spi_fsm_d = 0;
	
	always @ (posedge clk) begin 
			Spi_fsm 	<= Spi_fsm_d; 
			Spi_fsm_d 	<= Spi_fsm_d; 			
	end

	
///////////////////////ASSIGNMENTS//////////////////////////	
//	assign fsm_State = fsm_d;
//	assign ODatareg = SpiDataReg;
	assign cs =  cs_o;
	assign wr_en_o = ififo_wr_en;
	assign sclk_o = (valid_data1)? sclk : 1'b0; 
	assign sclk = (SPI_EDGE )? modsclk : ~modsclk; 	
	assign Spi_fsmd = Spi_fsm;
	assign Spi_Status = {ififo_rd_en, ofifo_full, ofifo_wr_en, ofifo_rd_en,TxDone,
								data_count_i, ofifo_empty,ififo_empty, miso, cs_o, mosi, sclk_o};
	
	always @(posedge clk)begin //posedge Clk_100MHz

		case (baddr)
			SPI_CTRL:begin 
				case(command)
					SPI_WRITE:begin //if spi write fifo is not full then load data 
							if(!ififo_full && Enable)begin // Send_data && 
								case(Spi_fsm)
									0:Spi_fsm_d <= 1;
									1:begin 
										if(w_ack != 1'b0)begin clrw_ack <= 1'b1; Spi_fsm_d <= 1;end
										else if(clrw_ack != 0)begin clrw_ack <= 1'b0; Spi_fsm_d <= 1;end//wait from 0: to 2
										else Spi_fsm_d <= 2;
									end	
									2:begin ififo_wr_en 	<= 1'b1; Spi_fsm_d <= 3; end
									3:begin ififo_wr_en 	<= 1'b0; Spi_fsm_d <= 4; end
									4:begin 
										if(w_ack != 1'b1)Spi_fsm_d <= 4;
										else begin clrw_ack <= 1'b1; Spi_fsm_d <= 5;end
									end
									5:if(clrw_ack != 0)begin clrw_ack <= 1'b0; Spi_fsm_d <= 5; Disable <= 1;end
									default:;
								endcase
							end
							else begin Spi_fsm_d <= 0; Disable <= 0; end
					end	
					SPI_READ:begin  //if spi read fifo is not empty then load data 
							if(ofifo_empty != 1'b1 && Enable)begin
								case(Spi_fsm)
									0:Spi_fsm_d 	<= 11;
									11:begin ofifo_rd_en 	<= 1'b1; Spi_fsm_d <= 12; end
									12:begin ofifo_rd_en 	<= 1'b0; Spi_fsm_d <= 13; end
									13:begin Spi_fsm_d <= 13; Disable <= 1;end
								endcase
							end
							else begin Spi_fsm_d <= 0; Disable <= 0; end
					end
					SPI_START:begin
							if(Enable)begin // Send_data && 
								case(Spi_fsm)
									0:Spi_fsm_d 	<= 23;
									21:Spi_fsm_d 	<= 22;
									22:Spi_fsm_d 	<= 23;
									23:begin start_en  <= 1'b1; Spi_fsm_d <= 24; end
									24:if(TxDone <= 1'b0)begin start_en <= 1'b0; Spi_fsm_d <= 25; end
									25:Disable <= 1;
								endcase
							end
							else begin Spi_fsm_d <= 0; Disable <= 0; end
					end
					CLEAR_CMD: begin
							Spi_fsm_d 	<= 1'b0;
							Spi_fsm_d 	<= 1'b0;
							ofifo_rd_en 		<= 1'b0; 
							ififo_wr_en <= 1'b0;						
					end	
					RST_CMD:begin //if spi write fifo is not full then load data  
							if(TxDone==0 && Enable)begin
								case(Spi_fsm)
									0:Spi_fsm_d 	<= 31; //wait from 0: to 2:
									31:begin ififo_wr_en <= 1'b0; Spi_fsm_d <= 32; end
									32:begin ofifo_rd_en <= 1'b0; Spi_fsm_d <= 33; end
									33:begin start_en  <= 1'b0; Spi_fsm_d <= 34; end
									34:Disable <= 1;
									default:;
								endcase
							end	
							else begin Spi_fsm_d <= 0; Disable <= 0;end
					end				
					default:;
				endcase
			end
		 default:;	
		 endcase
	end	
//////////////////////////////////////////////////////////////////////
		

	always @ (posedge clk) begin 
			fsm <= fsm_d; 
			fsm_d <= fsm_d;
			end
	
   localparam 
      START					= 0,
		ififo_rd_en_rise 	= 1,
		ififo_rd_en_fall 	= 2,
		GetLoWord			= 3,
		WAIT0					= 4,
		GetHiWord			= 5,
		WAIT1					= 6,
		WAIT2					= 7,
		ofifo_wr_en_rise1 = 8,
		ofifo_wr_en_fall1 = 9,
		ofifo_wr_en_rise2 = 10,
		ofifo_wr_en_fall2 = 11,
		WAIT3					= 12,
		IDLE					= 13;
	
always @ (posedge clk) begin
		case (fsm)
		   START:begin//0
						if(!ififo_empty && start_en == 1 && ififo_valid == 0)begin TxDone <= 1'b1; fsm_d <= ififo_rd_en_rise; end
						//else if(rst)cs_o <= 1'b1;
						else begin  //wr_empty
							//cs_o <= 1'b1;
							TxDone <= 1'b0;
							Enable_Vdata2 <=  1'b0;
							fsm_d <= START;
					   end	
						
					end
										
			ififo_rd_en_rise:begin//1
						ififo_rd_en <= 1'b1; //wr_en <= 1'b1; //Get next byte from ififo to transmitt
						fsm_d <= ififo_rd_en_fall;
					end			
			ififo_rd_en_fall:begin//2
						ififo_rd_en <= 1'b0;
						if(valid_data2 == 1 && DataSize >= 16'h18)fsm_d <= GetHiWord;
						else fsm_d <= GetLoWord;
					end	
			GetLoWord:begin //3
							if(valid_data1 == 1)begin
							  SpiDataBuff[15:0] <= ififo_data_o; // Save data to output reg
							  fsm_d <= WAIT0;
								fsm_d <= WAIT0;
						   end	
							//else fsm_d <= WAIT0;
						 end	
			WAIT0:begin //4
						if( DataSize >= 24)begin //ififo_valid != 1 &&
							fsm_d <= START;
							Enable_Vdata2 <= 1;
						end
						else fsm_d <= WAIT1;
					end
			GetHiWord:begin //5
								if(valid_data2) begin 
								SpiDataBuff[31:16] <= ififo_data_o;// Save data to output reg
								fsm_d <= WAIT1;
								fsm_d <= WAIT1;
								end
								//else fsm_d <= WAIT0;
						 end
							
			WAIT1:begin//6
						if(valid_data1)fsm_d <= WAIT2; //begin cs_o <= 1'b0; fsm_d <= WAIT2;end // Start Data transmission 
						else fsm_d <= WAIT1; 
					end
			WAIT2:begin//7
						if(clr_Vdata  != 1'b1) fsm_d <= WAIT2;  //clr_Vdata  <= 1'b1   wr_cnt != DataSize+1
						else fsm_d <= ofifo_wr_en_rise1;//else begin cs_o <= 1'b1; fsm_d <= ofifo_wr_en_rise1;end
					end	
			ofifo_wr_en_rise1:begin//8
						ofifo_data_i <= SpiDataReg[15:0];
						ofifo_wr_en <= 1'b1; //ofifo_wr <= 1'b1; //save byte from miso to ofifo	
						fsm_d <= ofifo_wr_en_fall1;
					end
					
			ofifo_wr_en_fall1:begin//9
						ofifo_wr_en <= 1'b0;	
						if(DataSize >= 24)fsm_d <= ofifo_wr_en_rise2;
						else fsm_d <= WAIT3;
					end
			ofifo_wr_en_rise2:begin//10						
						ofifo_data_i <= SpiDataReg[31:16];
						ofifo_wr_en <= 1'b1; //ofifo_wr <= 1'b1; //save byte from miso to ofifo	
						fsm_d <= ofifo_wr_en_fall2;
					end
					
			ofifo_wr_en_fall2:begin//11
						ofifo_wr_en <= 1'b0;	
						fsm_d <= WAIT3;  //START;
					end		
			WAIT3:begin//12
						if(valid_data1) fsm_d <= WAIT3;
						else begin fsm_d <= START; TxDone <= 1'b0;end// fsm_d <= ofifo_wr_en_rise;
					end
			IDLE:fsm_d <= START;	//13
			default:;
		endcase	
	end
	
	//Send Data on negedge sclk via MOSI
   reg [5:0]wr_cnt = 0;	
	reg [5:0]rd_cnt = 0;
	// Shift SpiDataBuff out via SpiDataReg while receiving miso data back into SpiDataReg
	always @ (posedge sclk) begin // due to timing delays must run on posedge for negedge transmission
		if(valid_data1)begin // && ififo_valid
			case(wr_cnt)
							0:;
							1:SpiDataReg <= SpiDataBuff;
							2:cs_o <= 1'b0;
				DataSize+3:begin cs_o <= 1'b1; clr_Vdata <= 1'b1; end//clr_Vdata  <= 1'b1;
				
				default:begin 
							if(DataSize == 32)SpiDataReg <= {SpiDataReg[30:0],miso}; //ififo_data_o <= {ififo_data_o[6:0], ififo_data_o[0]};	
						   else if(DataSize == 24)SpiDataReg <= {SpiDataReg[22:0],miso};
							else if(DataSize == 16)SpiDataReg <= {SpiDataReg[14:0],miso};
						   else SpiDataReg <= {SpiDataReg[6:0],miso};
				end	
			endcase
			if(wr_cnt <= (DataSize+6)) wr_cnt <= wr_cnt + 1;
		end
		else if(valid_data1 != 1 )begin clr_Vdata  <= 1'b0;  wr_cnt <= 0; end
	end

 assign mosi = {SpiDataReg[(DataSize-1)]};
endmodule
