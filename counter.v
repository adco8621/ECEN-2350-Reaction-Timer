module counter(in,rst,out);
input in,rst;
output reg [13:0] out = 0;

always @(posedge in)
begin

	if((out < 9999) && (rst == 0))
		out = out + 1;
	else if((out == 9999) || (rst == 1))
		out = 0;

end
endmodule