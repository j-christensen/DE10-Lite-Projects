
module hellow_world (
	clk_clk,
	reset_reset_n,
	hex5_external_connection_export,
	hex4_external_connection_export,
	hex3_external_connection_export,
	hex2_external_connection_export,
	hex1_external_connection_export,
	hex0_external_connection_export,
	led_external_connection_export,
	switch_external_connection_export,
	button_external_connection_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	hex5_external_connection_export;
	output	[7:0]	hex4_external_connection_export;
	output	[7:0]	hex3_external_connection_export;
	output	[7:0]	hex2_external_connection_export;
	output	[7:0]	hex1_external_connection_export;
	output	[7:0]	hex0_external_connection_export;
	output	[9:0]	led_external_connection_export;
	input	[9:0]	switch_external_connection_export;
	input	[1:0]	button_external_connection_export;
endmodule
