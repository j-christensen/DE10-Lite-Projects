module ClockDivide
	#(parameter WIDTH = 32)
	(input ClkIn,
	input [WIDTH-1:0] Factor,
	output ClkOut);
	
	reg [WIDTH-1:0] Cnt;
	wire [WIDTH-1:0] CntNxt;
	reg ClkTrack;
	
	always @ (posedge ClkIn)
	begin
		if (CntNxt == Factor/2)
			begin
				Cnt <= 0;
				ClkTrack<=~ClkTrack;
			end
		else
			Cnt <= CntNxt;
	end
	assign CntNxt = Cnt +1;
	assign ClkOut = ClkTrack;
endmodule
