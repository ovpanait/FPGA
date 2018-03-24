module verilog_test(
		    input 	     clk, start,
		    input [7:0]      x,
		    output reg [7:0] xpower,
		    output 	     finished);
   
   
   reg [7:0] 			     ncount;
   
   
   assign finished = (ncount == 0);
   
   
   always@(posedge clk)
     if (start)
       begin
	  xpower <= x;
	  
	  ncount <= 2;

       end
     else if (!finished)
       begin
	  ncount <= ncount - 1;

	  xpower <= xpower * x;

       end
endmodule
