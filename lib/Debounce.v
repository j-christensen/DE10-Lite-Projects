module Debounce(
	input i_clk,
	input [NIN-1:0] sig_in,
	output reg [NIN-1:0] DBSig,
	output reg Stable);

	//parameters that affect the implementation of the module
	parameter NIN=4;
	parameter NPause=21;
	
	reg [NPause-1:0] counter;
	reg [NIN-1:0] sigLast0;
	reg [NIN-1:0] sigLast1;
	
	initial 
		begin
			DBSig={(NIN){1'b0}};
			Stable=1'b1;
			counter=0;
	end
	
	//synchronize the switch input to the clock
	always @ (posedge i_clk) 
		begin
			sigLast0<=sig_in;
			sigLast1<=sigLast0;
		end
	
	always @ (posedge i_clk)
		case(Stable)
			1'b1: //Signal is stable
				if(sigLast0!=sigLast1)
					begin
						Stable<=1'b0;
						DBSig<=sigLast0;//change output to new signal
						counter<=0;
					end
				//else no need to change anything
			
			1'b0: //Signal is not stable
				if(counter=={(NPause){1'b1}})//signal has stabilized
					begin
						Stable<=1'b1;
						DBSig<=sigLast0;
					end
				else if(sigLast0!=sigLast1)//signal is changing still
					counter<=0;
				else
					counter<=counter+1;
		endcase
endmodule