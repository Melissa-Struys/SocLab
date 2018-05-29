module clk_div(clk_in, clk_out, rst);
 input clk_in, rst;
 output clk_out;
 
 reg clk;
 assign clk_out = clk;
 
 parameter out_period_count = 5-1; // 50MHz/10MHz-1
 reg [(out_period_count-1)/2:0] count;
 
 always@(posedge clk_in)
	begin
		if(rst) begin
			count = 0;
			clk = 0;
		end else begin
			if(count == out_period_count) begin
				count = 0;
			end else begin
				count = count + 1;
			end
			if(count > out_period_count/2) begin
				clk = 1;
			end else begin
				clk = 0;
			end
		end
	end
	
endmodule