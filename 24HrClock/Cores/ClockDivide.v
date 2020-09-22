module ClockDivide
	#(parameter WIDTH = 32)
	(input reset,
	input ClkIn,
	input [WIDTH-1:0] Factor,
	output ClkOut);
	
	reg [WIDTH-1:0] Cnt;
	wire [WIDTH-1:0] CntNxt;
	reg ClkTrack;
	
	always @ (posedge ClkIn)
		if(reset)
			begin
				Cnt<=0;
				ClkTrack<=1;
			end
		else if (CntNxt == Factor/2)
			begin
				Cnt <= 0;
				ClkTrack<=~ClkTrack;
			end
		else
			Cnt <= CntNxt;

	assign CntNxt = Cnt +1;
	assign ClkOut = ClkTrack;
endmodule
