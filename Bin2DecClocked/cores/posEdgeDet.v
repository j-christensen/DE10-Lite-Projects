module posEdgeDet(
	input [9:0] sig,
	input clk,
	output pulse);
	
	reg [9:0] sig_dly;
	reg diff;
	
	always @ (posedge clk)
		begin
			sig_dly<=sig;
		end
		
	assign diff=sig ^ sig_dly;
	assign pulse = |diff;
endmodule
