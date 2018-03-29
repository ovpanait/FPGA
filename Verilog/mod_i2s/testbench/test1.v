// test scenario #1
//resetsim();
//reset_fpga();

$display("Begin testing scenario 1... \n");

data_line = 0;
lrclk = 0; #100

lrclk = 1; #10
data_line = 1; #80
data_line = 0; #70
data_line = 1; #10

data_line = 0;
lrclk = 0; #30
verify_output(data_right, 16'hFF01);

#150

$display("\nCompleted testing scenario 1 with %d errors", errors);