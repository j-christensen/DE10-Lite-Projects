module Clock_Top(
	input	MAX10_CLK1_50,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [7:0] HEX3,
	output [7:0] HEX4,
	output [7:0] HEX5,
	input [1:0] KEY,
	output [9:0] LEDR,
	input [9:0]	SW);

	parameter Run=1'd0;
	parameter SetHr=2'd1;
	parameter SetMin=2'd2;
	parameter SetSec=2'd3;
//=======================================================
//  REG/WIRE declarations
//=======================================================

reg	[1:0]		ClkState;
wire	in_runstate;
reg	in_runstate_Delay;
wire	[1:0]		KEY_DB;
wire	[9:0]		SW_DB;
reg	[4:0]		Hr;
reg	[5:0]		Min;
reg	[5:0]		Sec;
wire	[3:0]		Hr0;
wire	[3:0]		Hr1;
wire	[3:0]		Min0;
wire	[3:0]		Min1;
wire	[3:0]		Sec0;
wire	[3:0]		Sec1;
wire	[3:0]		BCD0;
wire	[3:0]		BCD1;
wire	[3:0]		BCD2;
wire	[3:0]		BCD3;
wire	[3:0]		BCD4;
wire	[3:0]		BCD5;
wire	ClkReset;

reg [1:0] BtnDelay;
wire [1:0] BtnPulse;

wire ClkSec;
reg ClkSecDelay;
wire ClkSecPulse;

//=======================================================
//  Structural coding
//=======================================================
assign LEDR=SW_DB;

assign Hr0 = Hr % 10;
assign Hr1 = Hr / 10;
assign Min0 = Min % 10;
assign Min1 = Min / 10;
assign Sec0 = Sec % 10;
assign Sec1 = Sec / 10;

assign BCD0 = (ClkState==SetSec) ? (ClkSec ? Sec0 : 4'd10) : Sec0;
assign BCD1 = (ClkState==SetSec) ? (ClkSec ? Sec1 : 4'd10) : Sec1;
assign BCD2 = (ClkState==SetMin) ? (ClkSec ? Min0 : 4'd10) : Min0;
assign BCD3 = (ClkState==SetMin) ? (ClkSec ? Min1 : 4'd10) : Min1;
assign BCD4 = (ClkState==SetHr) ? (ClkSec ? Hr0 : 4'd10) : Hr0;
assign BCD5 = (ClkState==SetHr) ? (ClkSec ? Hr1 : 4'd10) : Hr1;

//turn ClkSec into a 1 clock pulse
always @(posedge MAX10_CLK1_50)
	ClkSecDelay<=ClkSec;
assign ClkSecPulse = (ClkSec)&(~ClkSecDelay);

//turn Btn presses into a 1 clock pulse
always @(posedge MAX10_CLK1_50)
	BtnDelay<=KEY_DB;
assign BtnPulse=(KEY_DB)&(~BtnDelay);

assign in_runstate = (ClkState == Run);
	
always @(posedge MAX10_CLK1_50)
	in_runstate_Delay<=in_runstate;
	
assign ClkReset=in_runstate & (~in_runstate_Delay);
	
always @(posedge MAX10_CLK1_50)
	case(ClkState)
		Run:
			if (SW_DB[0])
				ClkState<=SetHr;
			else //run clock
				if(ClkSecPulse)// increment clock
					if(Sec==59)
						begin
							Sec<=0;
							if(Min==59)
								begin
									Min<=0;
									if(Hr==23)
										Hr<=0;
									else
										Hr<=Hr+1;
								end
							else
								Min<=Min+1;
						end
					else
						Sec<=Sec+1;
		SetHr:
			if (!SW_DB[0])
				ClkState<=Run;
			else if(BtnPulse[0])//change to MinSet
				ClkState<=SetMin;
			else if(BtnPulse[1])
					Hr<=(Hr+1) % 24;
					//else do nothing to HrTmp
		SetMin:
			if (!SW_DB[0])
				ClkState<=Run;
			else if(BtnPulse[0])//change to MinSet
				ClkState<=SetSec;
			else if(BtnPulse[1])
					Min<=(Min+1) % 60;
					//else do nothing to HrTmp
		SetSec:
			if (!SW_DB[0])
				ClkState<=Run;
			else if(BtnPulse[0])//change to SetHr
				ClkState<=SetHr;
			else if(BtnPulse[1])
					Sec<=(Sec+1) % 60;
					//else do nothing to Sec
	endcase
	
bcd7seg seg0(
	.bcd(BCD0),
	.dot(1'b0),
	.seg(HEX0)
);

bcd7seg seg1(
	.bcd(BCD1),
	.dot(1'b0),
	.seg(HEX1)
);

bcd7seg seg2(
	.bcd(BCD2),
	.dot(ClkSec),
	.seg(HEX2)
);

bcd7seg seg3(
	.bcd(BCD3),
	.dot(1'b0),
	.seg(HEX3)
);

bcd7seg seg4(
	.bcd(BCD4),
	.dot(ClkSec),
	.seg(HEX4)
);

bcd7seg seg5(
	.bcd(BCD5),
	.dot(1'b0),
	.seg(HEX5)
);	
	
ClockDivide CD0(
	.reset(ClkReset),
	.ClkIn(MAX10_CLK1_50),
	.Factor(32'd50_000_000),
	.ClkOut(ClkSec));

Debounce #(.NIN(2)) D0(
	.i_clk(MAX10_CLK1_50),
	.sig_in(~KEY),
	.DBSig(KEY_DB));
	
Debounce #(.NIN(10)) D1(
	.i_clk(MAX10_CLK1_50),
	.sig_in(SW),
	.DBSig(SW_DB));

endmodule
