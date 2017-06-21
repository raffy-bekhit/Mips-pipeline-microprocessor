module flopenrc #(parameter WIDTH = 8)
(input logic clk, reset,
input logic en, clear,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q);
always_ff @(posedge clk, posedge reset)
if (reset) q <= #1 0;
else if (clear) q <= #1 0;
else if (en) q <= #1 d;
endmodule