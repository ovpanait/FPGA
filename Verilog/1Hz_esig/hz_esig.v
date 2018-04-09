`define CNT_VAL 26'd49999999

module hz_esig(
	       input 	  clk,
	       input 	  reset,
	       output reg enable
	       );

   // Generate 1Hz enable signal from 50MHz input clk
   // Enable signal high for only one clock cycle
   // Adapted exercise from:
   // https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-111-introductory-digital-systems-laboratory-spring-2006/assignments/pset2.pdf

   reg [25:0] 		  counter;
   
   always @(posedge clk)
     begin
	enable <= 0;
	
	if (reset == 1'b1)
	  counter <= 26'd0;
	else if (counter == `CNT_VAL) begin
	   counter <= 26'd0;
	   enable <= 1'b1;
	end
	else 
	  counter <= counter + 26'd1;
     end // always @ (posedge clk)
endmodule // hz_esig
