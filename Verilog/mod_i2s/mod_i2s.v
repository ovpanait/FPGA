`define BITS_NO 16

module mod_i2s(
	       input 		 bclk,
	       input 		 lrclk,
	       input 		 data_line,
	       output reg [15:0] data_left,
	       output reg 	 strobe_left,
	       output reg [15:0] data_right,
	       output reg 	 strobe_right
	       );

   reg 				 lrclk_prev;
   reg 				 get_data;
   reg 				 datain;
   reg [4:0] 			 bits_cnt;
   reg [15:0] 			 data_reg;
   reg 				 trigger_left, trigger_right;

   assign lrck_fall = lrclk_prev & !lrclk;
   assign lrck_rise = !lrclk_prev & lrclk;

   always @(posedge bclk)
     begin
	lrclk_prev <= lrclk;
	trigger_left <= lrck_rise;
	trigger_right <= lrck_fall;

	// Delay input data one clock cycle to synchronize with get_data
	datain <= data_line;
	get_data <= (bits_cnt != 0);

	if (get_data)
	  data_reg <= {data_reg[14:0], datain};

	if (lrck_fall || lrck_rise)
	  bits_cnt <= 'h10;

	// MSB first
	else if (bits_cnt != 0)
	  bits_cnt <= bits_cnt - 1;


	// Move data to left/right registers
	if (trigger_left) begin
	   strobe_left <= 1;
	   strobe_right <= 0;
	   data_left <= data_reg;
	end
	else if (trigger_right) begin
	   strobe_right <= 1;
	   strobe_left <= 0;
	   data_right <= data_reg;
	end
	else begin
	   strobe_right <= 0;
	   strobe_left <= 0;
	end // else: !if(trigger_right)

     end // always @ (posedge bclk)
endmodule // mod_i2s

