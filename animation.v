module animation(clk, rst, ram_address, ram_data);
 input clk, rst;
 input [8:0] ram_address;
 output [47:0] ram_data;
 
 wire [8:0] ram_addr;
 wire [47:0] ram_dt;
 
 assign ram_addr = ram_address;
 assign ram_data = {blue2, green2, red2, blue1, green1, red1};
 
 parameter rgb_res = 24;
 
 wire [7:0] red1, red2, green1, green2, blue1, blue2;
 
 reg [rgb_res-1:0] r1, r2, g1, g2, b1, b2;
 
 reg r1_sign, r2_sign, g1_sign, g2_sign, b1_sign, b2_sign;
 
 reg [17:0] r1_lfsr;
 reg [19:0] r2_lfsr;
 reg [22:0] g1_lfsr;
 reg [24:0] g2_lfsr;
 reg [27:0] b1_lfsr;
 reg [30:0] b2_lfsr;
 
 reg clk_ena;
 reg [8:0] buf_address;
 
 assign red1 = r1[rgb_res-1:rgb_res-8];
 assign red2 = r2[rgb_res-1:rgb_res-8];
 assign green1 = g1[rgb_res-1:rgb_res-8];
 assign green2 = g2[rgb_res-1:rgb_res-8];
 assign blue1 = b1[rgb_res-1:rgb_res-8];
 assign blue2 = b2[rgb_res-1:rgb_res-8];
 
 
 
 always@(posedge clk) 
	begin
		if (rst) begin
			r1_lfsr = 17'b11111111111111111;
			r2_lfsr = 19'b1111111111111111111;
			g1_lfsr = 22'b1111111111111111111111;
			g2_lfsr = 24'b111111111111111111111111;
			b1_lfsr = 27'b111111111111111111111111111;
			b2_lfsr = 30'b111111111111111111111111111111;
		end else begin			
			if(clk_ena == 1) begin
				r1_lfsr = {r1_lfsr[16:0], (r1_lfsr[17] ^ r1_lfsr[10])};
				r2_lfsr = {r2_lfsr[18:0], (r2_lfsr[19] ^ r2_lfsr[16])};
				g1_lfsr = {g1_lfsr[21:0], (g1_lfsr[22] ^ g1_lfsr[17])};
				g2_lfsr = {g2_lfsr[23:0], (g2_lfsr[24] ^ g2_lfsr[21])};
				b1_lfsr = {b1_lfsr[26:0], (b1_lfsr[27] ^ b1_lfsr[24])};
				b2_lfsr = {b2_lfsr[29:0], (b2_lfsr[30] ^ b2_lfsr[27])};
			end
		end
	end 
	
 always@(posedge clk)
	begin
		if(rst) begin
			r1 = 0;
			r2 = 0;
			g1 = 0;
			g2 = 0;
			b1 = 0;
			b2 = 0;
			r1_sign = 1;
			r2_sign = 1;
			g1_sign = 1;
			g2_sign = 1;
			b1_sign = 1;
			b2_sign = 1;
		end else begin
			if(clk_ena == 1) begin
				if (r1_lfsr[1:0] == 0) begin
					if(r1_sign == 1) begin
						r1 = r1 + 1;
					end else begin
						r1 = r1 -1;
					end
				end
				if(r1 == 2**rgb_res-1) begin
					r1_sign = 0;
				end else if (r1 == 1) begin
					r1_sign = 1;
				end
				if(r2_lfsr[6:0] == 0) begin
					if(r2_sign == 1) begin
						r2 = r2 + 1;
					end else begin
						r2 = r2 - 1;
					end
				end
				if(r2 == 2**rgb_res-1) begin
					r2_sign = 0;
				end else if(r2 == 1) begin
					r2_sign = 1;
				end
				
				if (g1_lfsr[4:0] == 0) begin
					if(g1_sign == 1) begin
						g1 = g1 + 1;
					end else begin
						g1 = g1 -1;
					end
				end
				if(g1 == 2**rgb_res-1) begin
					g1_sign = 0;
				end else if (g1 == 1) begin
					g1_sign = 1;
				end
				if(g2_lfsr[1:0] == 0) begin
					if(g2_sign == 1) begin
						g2 = g2 + 1;
					end else begin
						g2 = g2 - 1;
					end
				end
				if(g2 == 2**rgb_res-1) begin
					g2_sign = 0;
				end else if(r2 == 1) begin
					g2_sign = 1;
				end
				
				if (b1_lfsr[4:0] == 0) begin
					if(b1_sign == 1) begin
						b1 = b1 + 1;
					end else begin
						b1 = b1 -1;
					end
				end
				if(b1 == 2**rgb_res-1) begin
					b1_sign = 0;
				end else if (b1 == 1) begin
					b1_sign = 1;
				end
				if(b2_lfsr[2:0] == 0) begin
					if(b2_sign == 1) begin
						b2 = b2 + 1;
					end else begin
						b2 = b2 - 1;
					end
				end
				if(b2 == 2**rgb_res-1) begin
					b2_sign = 0;
				end else if(b2 == 1) begin
					b2_sign = 1;
				end
			end
		end
	end
	
	
 always@(posedge clk) 
	begin
		buf_address = ram_addr;
		if(buf_address == ram_addr) begin
			clk_ena = 0;
		end else begin
			clk_ena = 1;
		end
	end 
		
endmodule