// ECEN2350 Project 2 - Spring 2019
// University of Colorado, Boulder
//
// Name: Addison Conzet
//


//////////////////////////
// Project2_top
//
// Do not remove inputs/ outputs that you don't use. However, any unused
// input/ outputs can remain unconnected in the pin planner.
//
module Project2_top(
	output	[7:0] HEX0,
	output	[7:0] HEX1,
	output	[7:0] HEX2,
	output  [7:0] HEX3,
	output	[9:0] LEDR,
	input	[9:0] SW,
	input	KEY0,
	input	KEY1,
	input	CLK_50MHZ, // unused
	input   CLK_10MHZ
);

reg [2:0] state; // State
reg [15:0] prev_score, hi_score ; // Scores. Initially 10 sec so they are easily beat
reg rst,lfsr_met, init; // to reset the counter
wire msClk; // clock in ms
wire [13:0] elapsed; // ms passed
wire [11:0] lfsrOut; //lfsr value
reg [11:0] current_lfsr; // lfsr value to use to wait
reg [9:0] led_reg; // LED out
wire [7:0] hi3,hi2,hi1,hi0,pr3,pr2,pr1,pr0; //score outputs
reg [7:0] hex3,hex2,hex1,hex0; // hex outputs
wire [15:0] hi_bcd,prev_bcd; // scores in BCD

assign LEDR[9:0] = led_reg[9:0];

Clock_divider div (CLK_10MHZ,msClk); // turns 10MHz into 1kHz
counter c0 (msClk,rst,elapsed); // counts ms passed
lfsr lf (elapsed,lfsrOut); // lfsr

dbldbl hi (hi_score,hi_bcd); // Binary to BCD Hi score
dbldbl prev (prev_score,prev_bcd); // Binary to BCD prev score

//////////////////////// Converting BCD to 7 Seg Hex ///////////
ssDisp hh3 ({1'b1,hi_bcd[15:12]},hi3);
ssDisp hh2 ({1'b0,hi_bcd[11:8]},hi2);
ssDisp hh1 ({1'b0,hi_bcd[7:4]},hi1);
ssDisp hh0 ({1'b0,hi_bcd[3:0]},hi0);
ssDisp pp3 ({1'b1,prev_bcd[15:12]},pr3);
ssDisp pp2 ({1'b0,prev_bcd[11:8]},pr2);
ssDisp pp1 ({1'b0,prev_bcd[7:4]},pr1);
ssDisp pp0 ({1'b0,prev_bcd[3:0]},pr0);

// assigning output hex's to hex regs
assign HEX3 = hi3;
assign HEX2 = hi2;
assign HEX1 = hi1;
assign HEX0 = hi0;


 //states
parameter zero = 0, one = 1, two = 2, three = 3, four = 4;

// state change conditions
assign zero2one = (KEY0 == 0);
assign zero2four = (KEY1 == 0);

assign one2two = ((SW == 0) && (KEY0 == 1));

assign two2zero = (KEY1 == 0);
assign two2one = ((KEY0 == 0) || (SW != 0));
assign two2three = (lfsr_met);

assign three2zero = (SW == ~led_reg);

assign four2zero = (KEY1 == 0);


// outputs based on states
always @(posedge CLK_10MHZ)
begin

	if(elapsed == current_lfsr)
		lfsr_met = 1;
	else
		lfsr_met = 0;
		
	if (~init && elapsed == 1) begin
		state = zero;
		prev_score = 9999;
		hi_score = 9999;
		rst = 0;
		lfsr_met = 0;
		led_reg = 10'b1111111111;
		init = 1;
	end

	if((rst==1) && (state != one)) // check to turn off reset signal 
		rst = 0;

	case(state)
		zero:
		begin
			if (zero2one)
				state = one;
			else if (zero2four)
				state = four;		
		
			hex0 <= pr0;
			hex1 <= pr1;
			hex2 <= pr2;
			hex3 <= pr3;
		end
		one:
		begin
		
			if (one2two) begin
				state = two;
				rst = 1;
				current_lfsr = lfsrOut;
			end
		
			hex0 <= 8'b11000000;
			hex1 <= 8'b11000000;
			hex2 <= 8'b11000000;
			hex3 <= 8'b11000000;
		end
		two:
		begin
		
			if (two2zero)
				state = zero;
			else if (two2one)
				state = one;
			else if (two2three) begin
				if(current_lfsr < 400)
					led_reg[0] <= 0;
				else if(current_lfsr >= 400 && current_lfsr < 800)
					led_reg[1] <= 0;
				else if(current_lfsr >= 800 && current_lfsr < 1200)
					led_reg[2] <= 0;
				else if(current_lfsr >= 1200 && current_lfsr < 1600)
					led_reg[3] <= 0;
				else if(current_lfsr >= 1600 && current_lfsr < 2000)
					led_reg[4] <= 0;
				else if(current_lfsr >= 2000 && current_lfsr < 2400)
					led_reg[5] <= 0;
				else if(current_lfsr >= 2400 && current_lfsr < 2800)
					led_reg[6] <= 0;
				else if(current_lfsr >= 2800 && current_lfsr < 3200)
					led_reg[7] <= 0;
				else if(current_lfsr >= 3200 && current_lfsr < 3600)
					led_reg[8] <= 0;
				else if(current_lfsr >= 3600 && current_lfsr < 4000)
					led_reg[9] <= 0;
				state = three;
				rst = 1;
			end
		
			hex0 <= 8'b11000000;
			hex1 <= 8'b11000000;
			hex2 <= 8'b11000000;
			hex3 <= 8'b11000000;
		end
		three:
		begin
		
			if (three2zero) begin
				state = zero;
				prev_score = elapsed;
				
				if(prev_score < hi_score)
					hi_score = prev_score;
			end
		
			hex0 <= pr0;
			hex1 <= pr1;
			hex2 <= pr2;
			hex3 <= pr3;
		end
		four:
		begin
		
			if (four2zero)
				state = zero;
		
			hex0 <= hi0;
			hex1 <= hi1;
			hex2 <= hi2;
			hex3 <= hi3;
		end
	endcase
end




endmodule
