module shiftReg(
	input reset,
	input shift_in,
	input clock,
	output shift_out,
	output [WIDTH-1:0] arr_out);
	
	parameter WIDTH = 4;
	
	reg [WIDTH-1:0] bits;
	
	assign shift_out = bits[WIDTH-1];
	assign arr_out = bits;
	
	always@(posedge clock or posedge reset)
		begin
		if(reset)
			bits<=8'd0;
		else
			begin
			bits <= bits << 1;
		
			bits[0] <= shift_in;
			end
		end
	
	endmodule
	