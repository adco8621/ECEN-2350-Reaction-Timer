//SevenSegment: MSB of input is decimal, rest gets changed to hex display

module ssDisp(in, out);

input [4:0] in;
output reg [7:0] out;

	always @ (in)
	begin
	
		case (in)
		
		5'b00000:out=8'b11000000;
		5'b00001:out=8'b11111001;
		5'b00010:out=8'b10100100;
		5'b00011:out=8'b10110000;
		5'b00100:out=8'b10011001;
		5'b00101:out=8'b10010010;
		5'b00110:out=8'b10000010;
		5'b00111:out=8'b11111000;
		5'b01000:out=8'b10000000;
		5'b01001:out=8'b10011000;
		5'b01010:out=8'b10001000;
		5'b01011:out=8'b10000011;
		5'b01100:out=8'b10100111;
		5'b01101:out=8'b10100001;
		5'b01110:out=8'b10000110;
		5'b01111:out=8'b10001110;
		5'b10000:out=8'b01000000;
		5'b10001:out=8'b01111001;
		5'b10010:out=8'b00100100;
		5'b10011:out=8'b00110000;
		5'b10100:out=8'b00011001;
		5'b10101:out=8'b00010010;
		5'b10110:out=8'b00000010;
		5'b10111:out=8'b01111000;
		5'b11000:out=8'b00000000;
		5'b11001:out=8'b00011000;
		5'b11010:out=8'b00001000;
		5'b11011:out=8'b00000011;
		5'b11100:out=8'b00100111;
		5'b11101:out=8'b00100001;
		5'b11110:out=8'b00000110;
		5'b11111:out=8'b00001110;
		endcase
	
	end
endmodule
	