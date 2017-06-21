module zeroext8(input logic [7:0] a,
output logic [31:0] y);
assign y = {{24'h000000}, a};
endmodule