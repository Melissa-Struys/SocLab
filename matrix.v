module matrix(r0, g0, b0, r1, g1, b1, a, b, c, d, clk, stb, oe, reset, knop1, knop2, knop3, clkout, y_latch);
 input clk, reset, knop1, knop2, knop3;
 output r0, g0, b0, r1, g1, b1, a, b, c, d, stb, oe, clkout;
 input [3:0] y_latch;

 assign clkout = klokpuls;
 
 reg red0, green0, blue0, red1, green1, blue1;
	assign r0 = red0;
	assign g0 = green0;
	assign b0 = blue0;
	assign r1 = red1;
	assign g1 = green1;
	assign b1 = blue1;

 reg latch;
	assign stb = latch;
	
 reg blank;
	assign oe = blank;
	
 wire [3:0] muis;
 reg [3:0] muismin;
	assign muis = y_latch;
	
 reg [3:0] row;
	assign a = row[0];
	assign b = row[1];
	assign c = row[2];
	assign d = row[3];
	
 reg [6:0] teller;
 reg tellerpuls;
 
 reg [6:0] kolom, kolomteller;
 
 reg [8:0] klokteller;
 wire klokpuls; 
 reg blank1, latch1, unblank;
 
 Clock50MHz klok( .refclk(clk), .rst(reset), .outclk_0(klokpuls));

 
 always@(posedge klokpuls)
	begin
		if (reset) begin 			
			latch = 0;
			blank = 0;
			row = 0;
			kolom = 0;
		end else begin
					if (kolom == 7'b1000000) begin
						kolom = 0;
						latch = 1;
						//if(muis != muismin) begin
							if (row == 15) begin
								row = 0;
							end else begin;
								row = row + 1;
							end 
							//muismin = muis;
						//end
					end else begin
						kolom = kolom + 1;
						latch = 0;
						case (row)
								0:	begin 
											red0 = 1;
											green0 = 0;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end 
								1: begin
											red0 = 1;
											green0 = 1;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								2: begin
											red0 = 0;
											green0 = 1;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								3: begin
											red0 = 0;
											green0 = 1;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								4: begin
											red0 = 0;
											green0 = 0;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								5: begin
											red0 = 1;
											green0 = 0;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								6: begin
											red0 = 1;
											green0 = 1;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								7:	begin 
											red0 = 1;
											green0 = 0;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end 
								8: begin
											red0 = 1;
											green0 = 1;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								9: begin
											red0 = 0;
											green0 = 1;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								10: begin
											red0 = 0;
											green0 = 1;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								11: begin
											red0 = 0;
											green0 = 0;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								12: begin
											red0 = 1;
											green0 = 0;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								13: begin
											red0 = 1;
											green0 = 1;
											blue0 = 1;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								14: begin
											red0 = 1;
											green0 = 0;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end 
								15: begin
											red0 = 1;
											green0 = 1;
											blue0 = 0;
											red1 = 0;
											green1 = 0;
											blue1 = 0;
									end
								default: begin
									red0 = 1;
									green0 = 0;
									blue0 = 0;
									red1 = 0;
									green1 = 0;
									blue1 = 0;
									end
							endcase
			end
		end
	end

/*
 always@(posedge clk) 
	begin
		if (reset) begin
			klokteller = 0;
			klokpuls = 0;
		end else begin			
			if (klokteller == 50) begin
				klokteller = 0;
				klokpuls = 1;
			end else begin
				klokteller = klokteller + 1;
				klokpuls = 0;
			end
		end
	end
*/	

 always@(posedge klokpuls) 
	begin
		if (reset) begin
			teller = 0;
			tellerpuls = 0;
		end else begin			
			if (teller == 64) begin
				teller = 0;
				tellerpuls = 1;
			end else begin
				teller = teller + 1;
				tellerpuls = 0;
			end
		end
	end

endmodule