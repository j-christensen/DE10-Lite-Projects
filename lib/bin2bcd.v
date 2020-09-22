module bin2bcd	(
	clk,
	reset,
	go, 					// starts calc
	bIn,			// binary input
	//BinTmp,
	bcd,	// bcd {...,thousands,hundreds,tens,ones}
	state_reg,
	done);
	
	parameter bW = 10;
	parameter dW=bW*28/93+1;
	
	input clk;
	input reset;
	input go;
	input[bW-1:0] bIn;
	//output reg [bW-4:0] BinTmp;
	output reg [dW*4-1:0] bcd;
	output reg done;
	
	//State Machine parameters
	parameter [1:0] idle=2'b00;
	parameter [1:0] init=2'b01;
	parameter [1:0] calc=2'b10;
	parameter [1:0] finish=2'b11;
	
	reg [bW-4:0] BinTmp;	//Temp reg for playing with
	reg [7:0] count;			//counter
	output reg [1:0] state_reg;	//Current state
	
	initial
		state_reg<=idle;
	
	integer i;
	
	//State Machine
	always @(posedge clk or posedge reset)
		begin
			if (reset)
				state_reg<=init;
//			else if (go)
//				state_reg<=init;
			else
				case (state_reg)
					idle:
						if(go)
							state_reg<=init;
					init:
						state_reg<=calc;
					calc:
						if (count>7*2) state_reg<=finish;
					finish:
						state_reg<=idle;
					default:
						state_reg<=idle;
				endcase
		end
	//counter
	always @ (posedge clk or posedge reset)
		begin
			if (reset)
				count <= 8'd0;
			else if (state_reg==init)
				count <= 8'd0;
			else if (state_reg==finish)
				count <= 8'd0;
			else if (state_reg==calc)
				count<=count+1;
		end
	
	// done register
	always @ (posedge clk or posedge reset)
		begin
			if(reset)
				done<=1'b0;
			else if (state_reg==finish)
				done<=1'b1;
			else 
				done<=1'b0;
		end
		
	//double dabble;
	always @ (posedge clk or posedge reset)
		begin
			if(reset)
				begin
					BinTmp<=10'd0;
					bcd<=24'd0;
				end
//			else if(state_reg==idle)
//				begin
//					BinTmp<=10'd0;
//					bcd<=24'd0;
//				end
			else if(state_reg==init)
				begin
					BinTmp<=bIn[6:0];
					bcd[15:3]<=13'd0;
					bcd[2:0]<=bIn[9:7];
				end
			else if(state_reg==calc)
				if(count<7*2) 
				begin
					if(count[0]==1'b0)
						begin
							for(i=0; i<dW; i=i+1)
								begin
									if(bcd[3+4*i -: 4] > 4) 
										bcd[3+4*i -: 4] <= bcd[3+4*i -: 4] + 4'd3;
								end
						end
					else 
						begin
							bcd <= bcd << 1;
							bcd[0] <= BinTmp[6];
							BinTmp <= BinTmp << 1;
						end
				end
		end
endmodule

