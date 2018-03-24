module pow3_pipe(
		    input 	      clk,
		    input 	      x,
		    output reg [23:0] x_out
		    );



   reg [7:0] 			      x_buf;

   reg [15:0] 			      x_sq;


   always @(posedge clk)
     begin
	// stage 1
	x_buf <= x;

	x_sq <= x * x;


	// stage 2
	x_out <= x_sq * x_buf;

     end // always @ (posedge clk)

endmodule
