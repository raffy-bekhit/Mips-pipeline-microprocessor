module dmem(input logic clk, we,
input logic [31:0] a, wd,
output logic [31:0] rd ,
input logic savebyte
);
reg [31:0] RAM[63:0];
initial
begin
$readmemh("data.dat",RAM);
end
assign rd = RAM[a[31:2]]; // word aligned
always @(posedge clk)
if (we)	begin
if(savebyte==0)
RAM[a[31:2]] <= wd;	 
else  RAM[a[31:2]][7:0] <= wd[7:0];
end
endmodule
