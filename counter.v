module counter(in,out);
input in;
output reg [13:0] out = 0;

always @(posedge in)
begin

	if(out < 9999)
		out = out + 1;
	else if(out == 9999)
		out = 0;

end
endmodule