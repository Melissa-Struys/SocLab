module gamma_table(clk, val_in, val_out);
 parameter color_res = 8;
 parameter gamma = 2.8;
 
 input clk;
 input [color_res-1:0] val_in;
 output [color_res-1:0] val_out;
 
 reg [color_res-1:0] val_o;
 assign val_out = val_o;
 
 reg [2**color_res-1:0]lut_type[color_res-1:0];
 
 /*
 function lut_init;
	input c;
	reg [2**color_res-1:0]lut_var[0:color_res-1];
	reg lut_element;
	reg [2**color_res-1:0] i;
	begin
		for(i=0; i<2**color_res-1; i = i +1) begin
			lut_element = (2**color_res-1) * ((i/(2**color_res-1))**gamma);
			lut_var[i] = lut_element;
		end
	end
	lut_init = lut_var;
 endfunction
 
 parameter c = 2.8;
 
 parameter [2**color_res-1:0]gamma_lut[0:color_res-1] = lut_init(c);
*/

 always@(posedge clk)
	begin
		val_o = val_in;
	end

endmodule