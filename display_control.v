module display_control(clk, rst, display_ena, ram_data, ram_address, display_rgb1, display_rgb2, d_addr, d_clk, d_oe, d_lat);
 input clk, rst, display_ena;
 input [47:0] ram_data;
 output [8:0] ram_address;
 output [2:0] display_rgb1, display_rgb2;
 output  [3:0] d_addr;
 output  d_clk, d_oe, d_lat;
 
 assign ram_address = address_ctr;
 
 reg [3:0] display_addr;
 reg display_clk, display_oe, display_lat;
 assign d_addr = display_addr;
 assign d_clk = display_clk;
 assign d_oe = display_oe;
 assign d_lat = display_lat;
 
 parameter gamma = 2.8;
 parameter wait_max = 2;
 parameter wait_res = 3;
 
 reg [8:0] pwm_ctr;
 reg pwm_inc, row_inc, col_inc;
 
 reg [7:0] red1, red2, green1, green2, blue1, blue2;
	assign display_rgb1[0] = red1;
	assign display_rgb1[1] = green1;
	assign display_rgb1[2] = blue1;
	assign display_rgb2[0] = red2;
	assign display_rgb2[1] = green2;
	assign display_rgb2[2] = blue2;
 
 reg [2:0] wait_ctr;
 reg wait_ena;
 
 reg [9:0] address_ctr;
 
 reg next_oe, disp_oe, disp_lat, disp_clk;
 
 reg [10:0] teller;
 wire [3:0] kleur, kleur2;
 
 reg[3:0] state, next_state;
 //st0_idle
 //st1_clock_high
 //st2_clk_low
 //st3_inc_ctr
 //st4_latch
 //st5_oe_high
 //st6_oe_low
 
 memory m1(	.address(address_ctr),
				.clock(clk),
				.q(kleur)
				);

 memory m2(	.address(address_ctr+1024),
				.clock(clk),
				.q(kleur2)
				);
				
				/*
 memory m2(	.address(ram_data[15:8]),
				.clock(clk),
				.q(green1)
				);
 memory m3(	.address(ram_data[23:16]),
				.clock(clk),
				.q(blue1)
				);
 memory m4(	.address(ram_data[31:24]),
				.clock(clk),
				.q(red2)
				);
 memory m5(	.address(ram_data[39:32]),
				.clock(clk),
				.q(green2)
				);
 memory m6(	.address(ram_data[47:40]),
				.clock(clk),
				.q(blue2)
				);
				*/
 always@(posedge clk) 
	begin
		if (rst) begin
			pwm_ctr = 0;
		end else begin			
			if (pwm_inc == 1) begin
				if(pwm_ctr == 128) begin
					pwm_ctr = 0;
				end else begin
					pwm_ctr = pwm_ctr + 1;
				end
			end
		end
	end 
 
 always@(posedge clk) 
	begin			
		if (wait_ena == 0) begin
			wait_ctr = 0;
		end else begin
			wait_ctr = wait_ctr + 1;
		end
	end 
 /*
 always@(posedge clk) 
	begin			
		if (rst) begin
			teller = 0;
		end else begin
			if(teller == 2047) begin
				teller = 0;
			end else begin
				teller = teller + 1;
			end
		end
	end
 */
 
 always@(posedge clk) 
	begin
		if (rst) begin
			address_ctr = 0;
			teller = 0;
		end else begin			
			if (col_inc == 1) begin
				if(pwm_inc == 1 && row_inc == 0) begin
					address_ctr = {address_ctr[9:6], 6'b000000} ;
					teller = 0;
				end else begin
					address_ctr = address_ctr + 1;
					teller = teller + 1;
				end
				red1 = kleur[0];
				green1 = kleur[1];
				blue1 = kleur[2];
				red2 = kleur2[0];
				green2 = kleur2[1];
				blue2 = kleur2[2];
			end
		end
	end 
 
 always@(posedge clk) 
	begin
		display_oe = disp_oe;
		display_lat = disp_lat;
		display_clk = disp_clk;
			if(disp_oe == 1 && disp_lat == 1) begin
				display_addr = address_ctr[9:6];
			end
	end 
 
 always@(posedge clk) 
	begin
		if (rst) begin
			state = 0;
			disp_oe = 0;
		end else begin			
			state = next_state;
			disp_oe = next_oe;
		end
	end  
 
 always@(state, display_ena, wait_ctr, address_ctr, pwm_ctr, disp_oe) 
	begin
		next_state = state;
		next_oe = disp_oe;
		row_inc = 0;
		col_inc = 0;
		pwm_inc = 0;
		wait_ena = 0;
		disp_clk = 1;
		disp_lat = 0;
		
		case(state)
			0:	begin
					if(display_ena == 1) begin
						next_state = 1;
					end
				end
			1: begin
					if(wait_ctr == wait_max) begin
						next_state = 2;
					end else begin
						wait_ena = 1;
					end
				end
			2:	begin
					disp_clk = 0;
					if(wait_ctr == wait_max) begin
						if(address_ctr[5:0] == 63) begin
							if(pwm_ctr == 0) begin
								next_state = 5;
							end else begin
								next_state = 4;
							end
						end else begin
							next_state = 3;
						end
					end else begin
						wait_ena = 1;
					end
				end
			3: begin
					wait_ena = 1;
					col_inc = 1;
					if(address_ctr[5:0] == 63) begin
						pwm_inc = 1;
					end
					if(pwm_ctr == 128) begin
						row_inc = 1;
					end
					if(disp_oe == 1) begin
						next_state = 6;
					end else begin
						next_state = 1;
					end
				end
			4: begin
					disp_lat = 1;
					if(wait_ctr == 2*wait_max) begin
						next_state = 3;
					end else begin
						wait_ena = 1;
					end
				end
			5: begin
					next_oe = 1;
					if(wait_ctr == 2*wait_max) begin
						next_state = 4;
					end else begin
						wait_ena = 1;
					end
				end
			6: begin
					if(wait_ctr == 2*wait_max) begin
						next_oe = 0;
						next_state = 1;
					end else begin
						wait_ena = 1;
					end
				end
			endcase 
	end 
 
 
endmodule