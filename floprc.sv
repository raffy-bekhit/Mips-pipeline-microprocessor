module floprc #(parameter WIDTH = 9)	 //changed width
(input logic clk, reset,
clear,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q);
always_ff @(posedge clk, posedge reset)
if (reset) q <= #1 0;
else if (clear) q <= #1 0;
else q <= #1 d;
endmodule

