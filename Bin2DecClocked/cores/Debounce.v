module Debounce(
	input i_clk,
	input [NIN-1:0] i_sig,
	output reg [NIN-1:0] sig_out);

	//parameters that affect the implementation of the module
	parameter NIN=2;
	parameter NPause=20;
	
	//synchronize the switch input to the clock
	reg [NIN-1:0] sig_sync0;
	always @ (posedge i_clk) 
		sig_sync0<=i_sig;
		
	reg [NIN-1:0] sig_sync1;
	always @ (posedge i_clk)
		sig_sync1<=sig_sync0;
		
	reg [NPause-1:0] counter={(NPause){1'b0}};
	
	always @ (posedge i_clk)
		if (sig_out==sig_sync1)
			counter<=0;
		else
			begin
				counter<=counter+1'b1;
				if(counter=={(NPause){1'b1}})
					sig_out<=sig_sync1;
			end
	
endmodule