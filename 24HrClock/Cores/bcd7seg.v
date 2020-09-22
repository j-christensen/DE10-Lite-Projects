module bcd7seg(
	input [3:0] bcd,
	input dot,
	output [7:0] seg
);

reg[6:0] tmp;

assign seg={~dot,tmp};

always @(*)begin
	case(bcd)
		4'h0 : 	tmp = 7'b1000000;
		4'h1 : 	tmp = 7'b1111001;
		4'h2 : 	tmp = 7'b0100100;
		4'h3 : 	tmp = 7'b0110000;
		4'h4 : 	tmp = 7'b0011001;
		4'h5 : 	tmp = 7'b0010010;
		4'h6 : 	tmp = 7'b0000010;
		4'h7 : 	tmp = 7'b1111000;
		4'h8 : 	tmp = 7'b0000000;
		4'h9 : 	tmp = 7'b0011000;
		default:	tmp = 7'b1111111;
	endcase
end	

endmodule
