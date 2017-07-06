
//
// testbench2017.v
// Verilog simulation test bench for QN17Verilog/main.v
//

// Cause undefined net names to generate compilation errors.  The
// default behavior is that an unknown name (e.g. the result of a
// spelling or typing error) will be treated as the name of a
// one-bit-wide wire.  Using the default can lead to bugs that are
// very difficult to track down, so I always make this the first
// line of any Verilog program.
`default_nettype none

// Set time units and precision for simulation
`timescale 1ns/1ps


module testbench2017;
    // The top level of a test bench usually has no inputs or
    // outputs, since its job is to provide the inputs and
    // outputs of the "Design Under Test" (i.e. your main
    // module).

    // For each input to the DUT, we need a Verilog register,
    // whose state we can manipulate at this top level.  For
    // each output of the DUT, we need a Verilog wire, whose
    // value we can observe at this top level.
    reg clk100 = 0;
    wire overflowLight;
    reg scin_coin = 0;
    reg [0:7] tube3a = 0;
    reg [0:7] tube3b = 0;
    reg [0:7] tube4a = 0;
    reg [0:7] tube4b = 0;
    wire [0:15] otube;
    reg rd_clk1 = 0;
    reg rd_en1 = 0;
    wire rd_empty;
    wire rd_valid;

    // Instantiate the DUT
    main dut
      ( .clk100(clk100),
	.overflowLight(overflowLight),
	.SCIN_COIN(scin_coin),
	.TUBE3A(tube3a),
	.TUBE3B(tube3b),
	.TUBE4A(tube4a),
	.TUBE4B(tube4b),
	.OTUBE(otube),
	.RD_CLK1(rd_clk1),
	.RD_EN1(rd_en1),
	.RD_EMPTY(rd_empty),
	.RD_VALID(rd_valid)
	);

    // Make the clock tick (forever)
    localparam CLKPERIOD = 10.0;
    initial begin
	while (1) begin
	    clk100 = 0;
	    #(CLKPERIOD/2.0);  // delay one-half clock period
	    clk100 = 1;
	    #(CLKPERIOD/2.0);
	end
    end

    // One microsecond after start of simulation,
    // send in a simulated cosmic-ray event.
    initial begin
	// Initialize everything to zero at t=0, even though this is
	// in fact already done with the "=0" in each "reg"
	// declaration above.
	scin_coin = 0;
	tube3a = 0;
	tube3b = 0;
	tube4a = 0;
	tube4b = 0;
	#1000;  // delay 1000 ns
	scin_coin = 1;
	#100;  // question: how long is the scin_coin pulse really?!
	scin_coin = 0;
	// question: how long are the shortest and longest drift times?
	#100;
	tube3a = 8'b00100000;
	#100;
	tube3b = 8'b00010000;
	#100;
	tube4a = 8'b00001000;
	#100;
	tube4b = 8'b00000100;
	#200;
	{tube3a, tube3b, tube4a, tube4b} = 32'b0;
    end

    // Terminate simulation at t = 3 microseconds.  Depending on how
    // slow your readout is, you may want to make this much later; or
    // you may want to remove this altogether.
    initial begin
	#3000;
	$finish();
    end

    // I have no idea what your readout protocol looks like, so for
    // that I will not even guess.  You need to make the simulation
    // waveforms resemble the signals that you would expect to see if
    // you observed the RPi-to-FPGA communication on an oscilloscope.

endmodule



// Undo the above "`default_nettype none", in case some other source
// file is (dangerously!) relying on using the default behavior.
`default_nettype wire