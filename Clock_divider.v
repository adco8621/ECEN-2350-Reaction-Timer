module Clock_divider(clk,out);

input clk;
output out;

reg out_reg = 0;

parameter divider = 10000;

reg [13:0] counter = 0;

assign out = out_reg;

always @ (posedge clk)
begin
	counter = counter + 1;
	if(counter == divider/2)
	begin
		counter = 0;
		out_reg = ~out_reg;
	end
end
endmodule