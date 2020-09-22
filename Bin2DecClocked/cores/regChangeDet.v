module regChangeDet(
	input [9:0] sig,
	input clk,
	output pulse);
	
	reg [9:0] sig_dly[1:0];
	wire [9:0] diff;
	
	always @ (posedge clk)
		begin
			sig_dly[0]<=sig;
			sig_dly[1]<=sig_dly[0];
		end
		
	assign diff=sig_dly[1] - sig_dly[0];
	//assign diff=sig^sig_dly[0];
	assign pulse = |diff;
endmodule
