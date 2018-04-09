// test scenario #1
//resetsim();
//reset_fpga();

$display("Begin testing scenario 1... \n");
$display("Testing 1Hz enable pulse ");

// Testcase init
wait(reset)
@(posedge clk);
@(negedge clk) reset = 0;

// Testcase
repeat(50000000) @(posedge clk);
@(negedge clk)
verify_output(enable, 1);

// Testcase end
reset = 1;
@(negedge clk);

$display("\nCompleted testing scenario 1 with %d errors", errors);
