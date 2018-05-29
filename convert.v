module convert(clk, address, data_out);
 input clk;
 input [9:0] address;
 output [47:0] data_out;

 wire [9:0] addr_upper, addr_lower;
	assign addr_upper = {1'b0, address};
	assign addr_lower = {1'b1, address};
 
 wire [3:0] data_in_upper, data_in_lower;
 
 reg [23:0] data_upper, data_lower;
 
 assign data_out = {data_upper, data_lower};
 
 memory m1(	.address(addr_upper),
				.clock(clk),
				.q(data_in_upper)
				);
				
 memory m2(	.address(addr_lower),
				.clock(clk),
				.q(data_in_lower)
				);

 always@(posedge clk)
	begin
		case(data_in_upper)
			1:	data_upper = 24'b000000000011001101100110;
			2: data_upper = 24'b111111110000000000000000;
			3: data_upper = 24'b111111111001111100000000;
			4: data_upper = 24'b111111111111111100000000;
			5: data_upper = 24'b001100111111111100000000;
			6: data_upper = 24'b000000001001101111111111;
			7: data_upper = 24'b011011010011001111111111;
			8: data_upper = 24'b111111111101001110010011;
			9: data_upper = 24'b111111111001100111111111;
			1'ha: data_upper = 24'b111111110011001010011111;
			1'hb: data_upper = 24'b100110011001100110011001;
			1'hc: data_upper = 24'b111111111001100110011001;
			1'hd: data_upper = 24'b111111111111111111111111;
			default: data_upper = 0;
		endcase
		
		case(data_in_lower)
			1:	data_lower = 24'b000000000011001101100110;
			2: data_lower = 24'b111111110000000000000000;
			3: data_lower = 24'b111111111001111100000000;
			4: data_lower = 24'b111111111111111100000000;
			5: data_lower = 24'b001100111111111100000000;
			6: data_lower = 24'b000000001001101111111111;
			7: data_lower = 24'b011011010011001111111111;
			8: data_lower = 24'b111111111101001110010011;
			9: data_lower = 24'b111111111001100111111111;
			1'ha: data_lower = 24'b111111110011001010011111;
			1'hb: data_lower = 24'b100110011001100110011001;
			1'hc: data_lower = 24'b111111111001100110011001;
			1'hd: data_lower = 24'b111111111111111111111111;
			default: data_lower = 0;
		endcase
	end
	
endmodule