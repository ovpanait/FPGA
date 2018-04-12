module reset_sync(
		  input clk,
		  input reset,
		  output reg reset_sync
		  );

   reg 			 ff;

   always @(posedge clk, negedge reset)
     begin
	if (reset == 0) begin
	    ff <= 0;
	   reset_sync <= 0;
	end
	else begin
	   ff <= 1;
	   reset_sync <= ff;
	end
     end // always @ (posedge clk, negedge reset)
endmodule // reset_sync

	   
	   
	   

	
