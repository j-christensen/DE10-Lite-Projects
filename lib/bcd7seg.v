module bcd7seg(
	input [3:0] bcd,
	output reg [7:0] seg
);

always @(*)begin
	case(bcd)
		4'h0 : 	seg = 8'b11000000;
		4'h1 : 	seg = 8'b11111001;
		4'h2 : 	seg = 8'b10100100;
		4'h3 : 	seg = 8'b10110000;
		4'h4 : 	seg = 8'b10011001;
		4'h5 : 	seg = 8'b10010010;
		4'h6 : 	seg = 8'b10000010;
		4'h7 : 	seg = 8'b11111000;
		4'h8 : 	seg = 8'b10000000;
		4'h9 : 	seg = 8'b10011000;
		default:	seg = 8'b11111111;
	endcase
end	

endmodule
