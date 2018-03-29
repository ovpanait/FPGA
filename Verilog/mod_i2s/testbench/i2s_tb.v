`timescale 1ns/1ns
`define PERIOD 5

module tb();

   // Module instantiation
   reg clk, lrclk;
   reg reset;
   reg data_line;
   wire [15:0] data_left;
   wire        strobe_left;
   wire [15:0] data_right;
   wire        strobe_right;

   mod_i2s DUT (
		.bclk(clk),
		.lrclk(lrclk),
		.data_line(data_line),
		.data_left(data_left),
		.data_right(data_right),
		.strobe_left(strobe_left),
		.strobe_right(strobe_right)
		);

   // Test setup
   integer     errors;

   initial begin
      clk <= 0;
      forever #(`PERIOD) clk = ~clk;
   end

   initial begin
      reset <= 0;
      @(posedge clk); //may need several cycles for reset
      @(negedge clk) reset = 1;
   end

   initial begin
      errors = 0; // reset error count

      // reset inputs to chip
      //chipin1 = 0;
      //chipin2 = 16’ha5;

      // reset simulation parameters
      //resetsim();

      // reset for chip
      //reset_fpga();

      //
      // Add testcases here
      //
`include "test1.v"

      $display("\nSimulation completed with %d errors\n", errors);
      $stop;
   end

   task verify_output;
      input [15:0] simulated_value;
      input [15:0] expected_value;
      begin
	 if (simulated_value[15:0] != expected_value[15:0])
	   begin
	      errors = errors + 1;
	      $display("Simulated Value = %h, Expected Value = %h,\
		errors = %d,\
		at time = %d\n", simulated_value, expected_value,
		       errors, $time);
	   end
end
endtask

endmodule
