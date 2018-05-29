module ledctrl(clk_in, rst, clk_out, rgb1, rgb2, led_addr, lat, oe, addr, data);
 parameter num_panels = 2;
 parameter pixel_depth = 8;
 parameter panel_width = 64;
 parameter panel_height = 32;
 parameter data_width = pixel_depth*6;
 parameter addr_width = 11;
 parameter img_width = panel_width*num_panels;
 parameter img_width_log2 = 7;


 input clk_in, rst;
 input [data_width-1:0] data;
 output clk_out, lat, oe;
 output [2:0] rgb1, rgb2;
 output [3:0] led_addr;
 output [addr_width-1:0] addr;
 
 wire clk;
 
 clk_div cd(	.clk_in(clk_in), 
					.clk_out(clk), 
					.rst(rst)
					);
 
 
 
  reg[2:0] state, next_state;
 //st0_init
 //st1_read_pixel_data
 //st2_incr_ram_addr
 //st3_latch
 //st4_incr_led_addr
 
 reg [img_width_log2:0] col_count, next_col_count;
 reg [pixel_depth-1:0] bpp_count, next_bpp_count;
 reg [3:0] s_led_addr, next_led_addr;
 reg [addr_width-1:0] s_ram_addr, next_ram_addr;
 reg [2:0] s_rgb1, s_rgb2;
 wire [2:0] next_rgb1, next_rgb2;
 reg s_oe, s_lat, s_clk_out;
 
 assign led_addr = s_led_addr; //plaats veranderen?
 assign addr = s_ram_addr;
 assign rgb1 = s_rgb1;
 assign rgb2 = s_rgb2;
 assign oe = s_oe;
 assign lat = s_lat;
 assign clk_out = s_clk_out;
 
 
 wire [(data_width/2)-1:0] upper, lower;
 wire [pixel_depth-1:0] upper_r, upper_g, upper_b, lower_r, lower_g, lower_b;
 reg r1, g1, b1, r2, g2, b2;
	
 assign upper = data[data_width-1:data_width/2];
 assign lower = data[data_width/2-1:0];
 assign upper_r = upper[3*pixel_depth-1:2*pixel_depth];
 assign upper_g = upper[2*pixel_depth-1:pixel_depth];
 assign upper_b = upper[pixel_depth-1:0];
 assign lower_r = lower[3*pixel_depth-1:2*pixel_depth];
 assign lower_g = lower[2*pixel_depth-1:pixel_depth];
 assign lower_b = lower[pixel_depth-1:0];
 assign next_rgb1 = {r1, g1, b1};
 assign next_rgb2 = {r2, g2, b2};

	
 always@(posedge clk)
	begin
		if(rst) begin
			state = 0;
			col_count = 0;
			bpp_count = 0;
			s_led_addr = 4'b1111;
			s_ram_addr = 0;
			s_rgb1 = 0;
			s_rgb2 = 0;
		end else begin
			state = next_state;
			col_count = next_col_count;
			bpp_count = next_bpp_count;
			s_led_addr = next_led_addr;
			s_ram_addr = next_ram_addr;
			s_rgb1 = next_rgb1;
			s_rgb2 = next_rgb2;
		end
	end
	
	
	
 always@(state, col_count, bpp_count, s_led_addr, s_ram_addr, s_rgb1, s_rgb2, data)
	begin
		next_col_count = col_count;
		next_bpp_count = bpp_count;
		next_led_addr = s_led_addr;
		next_ram_addr = s_ram_addr;
		/*
		next_rgb1 = s_rgb1;
		next_rgb2 = s_rgb2;
		*/
		s_clk_out = 0;
		s_lat = 0;
		s_oe = 0;
		
		case(state)
			0: begin
					if(s_led_addr == 4'b1111) begin
						if(bpp_count == 8'b11111110) begin
							next_bpp_count = 0;
						end else begin
							next_bpp_count = bpp_count + 1;
						end
					end
					next_state = 1;
				end
			1: begin
					if(upper_r > bpp_count) begin
						r1 = 1;
					end else begin
						r1 = 0;
					end
					if(upper_g > bpp_count) begin
						g1 = 1;
					end else begin
						g1 = 0;
					end
					if(upper_b > bpp_count) begin
						b1 = 1;
					end else begin
						b1 = 0;
					end
					if(lower_r > bpp_count) begin
						r2 = 1;
					end else begin
						r2 = 0;
					end 
					if(lower_g > bpp_count) begin
						g2 = 1;
					end else begin
						g2 = 0;
					end	
					if(lower_b > bpp_count) begin
						b2 = 1;
					end else begin
						b2 = 0;
					end	
					next_col_count = col_count + 1;
					if(col_count < img_width) begin
						next_state = 2;
					end else begin
						next_state = 3;
					end
				end
			2: begin
					s_clk_out = 1;
					s_oe = 1;
					next_ram_addr = s_ram_addr + 1;
					next_state = 1;
				end
			3: begin
					next_led_addr = s_led_addr + 1;
					next_col_count = 0;
					next_state = 4;
				end
			4: begin
					s_lat = 1;
					next_state = 0;
				end
		endcase
	end
	
endmodule