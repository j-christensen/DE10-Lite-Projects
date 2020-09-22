// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Alexandra Du			:| 06/01/2016:| Added Verilog file
// ============================================================================


//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

`define ENABLE_ADC_CLOCK
`define ENABLE_CLOCK1
`define ENABLE_CLOCK2
`define ENABLE_SDRAM
`define ENABLE_HEX0
`define ENABLE_HEX1
`define ENABLE_HEX2
`define ENABLE_HEX3
`define ENABLE_HEX4
`define ENABLE_HEX5
`define ENABLE_KEY
`define ENABLE_LED
`define ENABLE_SW
`define ENABLE_VGA
`define ENABLE_ACCELEROMETER
`define ENABLE_ARDUINO
`define ENABLE_GPIO

module DE10_LITE_Golden_Top(

	//////////// ADC CLOCK: 3.3-V LVTTL //////////
`ifdef ENABLE_ADC_CLOCK
	input 		          		ADC_CLK_10,
`endif
	//////////// CLOCK 1: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK1
	input 		          		MAX10_CLK1_50,
`endif
	//////////// CLOCK 2: 3.3-V LVTTL //////////
`ifdef ENABLE_CLOCK2
	input 		          		MAX10_CLK2_50,
`endif

	//////////// SDRAM: 3.3-V LVTTL //////////
`ifdef ENABLE_SDRAM
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,
`endif

	//////////// SEG7: 3.3-V LVTTL //////////
`ifdef ENABLE_HEX0
	output		     [7:0]		HEX0,
`endif
`ifdef ENABLE_HEX1
	output		     [7:0]		HEX1,
`endif
`ifdef ENABLE_HEX2
	output		     [7:0]		HEX2,
`endif
`ifdef ENABLE_HEX3
	output		     [7:0]		HEX3,
`endif
`ifdef ENABLE_HEX4
	output		     [7:0]		HEX4,
`endif
`ifdef ENABLE_HEX5
	output		     [7:0]		HEX5,
`endif

	//////////// KEY: 3.3 V SCHMITT TRIGGER //////////
`ifdef ENABLE_KEY
	input 		     [1:0]		KEY,
`endif

	//////////// LED: 3.3-V LVTTL //////////
`ifdef ENABLE_LED
	output		     [9:0]		LEDR,
`endif

	//////////// SW: 3.3-V LVTTL //////////
`ifdef ENABLE_SW
	input 		     [9:0]		SW,
`endif

	//////////// VGA: 3.3-V LVTTL //////////
`ifdef ENABLE_VGA
	output		     [3:0]		VGA_B,
	output		     [3:0]		VGA_G,
	output		          		VGA_HS,
	output		     [3:0]		VGA_R,
	output		          		VGA_VS,
`endif

	//////////// Accelerometer: 3.3-V LVTTL //////////
`ifdef ENABLE_ACCELEROMETER
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO,
`endif

	//////////// Arduino: 3.3-V LVTTL //////////
`ifdef ENABLE_ARDUINO
	inout 		    [15:0]		ARDUINO_IO,
	inout 		          		ARDUINO_RESET_N,
`endif

	//////////// GPIO, GPIO connect to GPIO Default: 3.3-V LVTTL //////////
`ifdef ENABLE_GPIO
	inout 		    [35:0]		GPIO
`endif
);

//=======================================================
// Parameter declarations
//=======================================================
 

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire [9:0] bin;
wire[23:0] bcd;
wire Clk1M;
wire binStart;
wire binDone;
wire reset;
wire [9:0] SWDB;
wire [1:0] KEYDB;

//=======================================================
//  Structural coding
//=======================================================
assign reset=~KEYDB[0];
assign bin=SWDB;
assign LEDR=bin;

regChangeDet SWDet(
	.sig(bin),
	//.clk(Clk1M),
	.clk(MAX10_CLK1_50),
	.pulse(binStart));

ClockDivide CD(
	.ClkIn(MAX10_CLK1_50),
	.Factor(32'd25000000),
	.ClkOut(Clk1M));

bin2bcd #(.bW(10)) binConv(
	.clk(MAX10_CLK1_50),
	.reset(reset),
	.go(binStart),
	.bIn(bin),
	.bcd(bcd),
	//.state_reg(LEDR[2:1]),
	.done(binDone));

Debounce #(.NIN(10)) S0(
	.i_clk(MAX10_CLK1_50),
	.i_sig(SW),
	.sig_out(SWDB));	

Debounce K0(
	.i_clk(MAX10_CLK1_50),
	.i_sig(KEY),
	.sig_out(KEYDB));	
bcd7seg Out0(.bcd(bcd[3:0]),.seg(HEX0));
bcd7seg Out1(.bcd(bcd[7:4]),.seg(HEX1));
bcd7seg Out2(.bcd(bcd[11:8]),.seg(HEX2));
bcd7seg Out3(.bcd(bcd[15:12]),.seg(HEX3));
bcd7seg Out4(.bcd(bcd[19:16]),.seg(HEX4));
bcd7seg Out5(.bcd(bcd[23:20]),.seg(HEX5));
endmodule