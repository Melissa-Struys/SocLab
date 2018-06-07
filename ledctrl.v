module ledctrl(clk_in, rst, clk_out, rgb1, rgb2, led_addr, lat, oe, addr, data, y_latch);
 parameter num_panels = 1;
 parameter pixel_depth = 8;
 parameter panel_width = 64;
 parameter panel_height = 32;
 parameter data_width = pixel_depth*6;
 parameter addr_width = 15;
 parameter img_width = 64; //panel_width*num_panels;
 parameter img_width_log2 = 7;
 parameter wait_max = 3;


 input clk_in, rst;
 input [data_width-1:0] data;
 input [7:0] y_latch;
 output clk_out, lat, oe;
 output [2:0] rgb1, rgb2;
 output [3:0] led_addr;
 output [addr_width-1:0] addr;
 
 wire clk;
 
 reg [7:0] s_muis;
 wire [7:0] next_muis;
 reg [7:0] s_muisvorige, next_muisvorige, s_muisverschil, next_muisverschil;
	assign next_muis = y_latch;
 reg verschoven, volgendefoto, stilstaan;
 reg [2:0] s_frame, next_frame;
 reg [3:0] s_foto, next_foto;
 
 
 klokje klok (
		.refclk   (clk_in),   //  refclk.clk
		.rst      (rst),      //   reset.reset
		.outclk_0 (clk), // outclk0.clk
		.locked   (0)    //  locked.export
	);

  reg[2:0] state, next_state;
 //st0_init
 //st1_frame_counter
 //st2_read_pixel_data
 //st3_incr_ram_addr
 //st4_incr_led_addr
 //st5_latch
 
 reg [img_width_log2:0] col_count, next_col_count;
 reg [pixel_depth-1:0] bpp_count, next_bpp_count;
 reg [3:0] s_led_addr, next_led_addr;
 reg [9:0] s_ram_addr, next_ram_addr;
 reg [2:0] s_rgb1, s_rgb2;
 wire [2:0] next_rgb1, next_rgb2;
 reg s_oe, s_lat, s_clk_out;
 
 assign led_addr = s_led_addr;
 assign addr = {s_foto, 1'b0, s_ram_addr};
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
			state = 1;
			col_count = 0;
			bpp_count = 0;
			s_led_addr = 15;
			s_ram_addr = 0;
			s_rgb1 = 0;
			s_rgb2 = 0;
			s_foto = 0;
			s_frame = 0;
		end else begin
			state = next_state;
			col_count = next_col_count;
			bpp_count = next_bpp_count;
			s_led_addr = next_led_addr;
			s_ram_addr = next_ram_addr;
			s_rgb1 = next_rgb1;
			s_rgb2 = next_rgb2;
			s_foto = next_foto;
			s_frame = next_frame;
			s_muis = next_muis;
		end
	end
	
 
 always@(state, col_count, bpp_count, s_led_addr, s_ram_addr, s_rgb1, s_rgb2, data, s_frame, s_foto)
	begin
		next_col_count = col_count;
		next_bpp_count = bpp_count;
		next_led_addr = s_led_addr;
		next_ram_addr = s_ram_addr;
		next_foto = s_foto;
		next_frame = s_frame;
		s_clk_out = 0;
		s_lat = 0;
		s_oe = 0;
		
		case(state)
			0: begin
					next_led_addr = 15;
					next_state = 1;
				end
			1: begin
					if(s_led_addr == 4'b1111) begin
						if(bpp_count == 8'b11111110) begin
							next_bpp_count = 0;
							next_muisverschil = s_muis - s_muisvorige;
							next_muisvorige = s_muis;
							if(s_muisverschil != 0) begin
								next_ram_addr[5:0] = s_ram_addr[5:0] + s_muisverschil[7:5];	
								stilstaan = 0;
							end else begin
								stilstaan = 1;
								next_ram_addr = 0;
							end
							if(s_frame == 3) begin
								if(s_foto == 11) begin
									next_foto = 0;
								end else begin
									next_foto = s_foto + 1;
								end
								next_frame = 0;
							end else begin
								next_frame = s_frame + 1;
							end
						end else begin
							next_bpp_count = bpp_count + 1;
						end
					end	
					if(bpp_count == 8'b11111110) begin
						next_state = 6;
					end else begin
						next_state = 2;
					end
				end
			2: begin
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
						next_state = 3;
					end else begin
						next_state = 4;
					end
				end
			3: begin
					s_clk_out = 1;
					if(stilstaan == 1) begin
						if(s_ram_addr == 1023) begin
							next_ram_addr = 0;
						end else begin
							next_ram_addr = s_ram_addr + 1;
						end
					end else begin
						if(s_ram_addr[5:0] == 6'b111111) begin
							next_ram_addr[5:0] = 0;
							if(s_foto == 11) begin
								next_foto = 0;
							end else begin
								next_foto = s_foto + 1;
							end
						end else begin
							next_ram_addr = s_ram_addr + 1;
						end
					end
					next_state = 2;
				end
			4: begin					
					s_oe = 1;
					if(stilstaan != 1) begin
						if(s_ram_addr[9:6] == 15) begin
							next_ram_addr[9:6] = 0;
						end else begin
							next_ram_addr[9:6] = s_ram_addr[9:6] + 1;
						end
						if(s_foto == 0) begin
							next_foto = 11;
						end else begin
							next_foto = s_foto - 1;
						end
					end
					if(s_led_addr == 15) begin
						next_led_addr = 0;
					end else begin
						next_led_addr = s_led_addr + 1;
					end
					next_col_count = 0;
					next_state = 5;
				end
			5: begin
					s_oe = 1;
					s_lat = 1;
					next_state = 1;
				end
			6: begin
					s_muisvorige = next_muisvorige;
					s_muisverschil = next_muisverschil;
					next_state = 2;
				end
		endcase
	end
	
endmodule
