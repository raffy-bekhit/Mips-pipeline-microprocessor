module multiply (input clk,input logic [31:0] srca,srcb,
input logic[5:0] funct,
output logic [31:0] outMU);

logic [31:0]hi,lo;
always_ff @(negedge clk)
begin
	case(funct)
  6'b010000:outMU<=hi;
  6'b010010:outMU<=lo;
  6'b011000:
  begin
    {hi,lo}<=(srca*srcb);
  end
  6'b011010:
  begin
    lo<=srca/srcb;
    hi<=srca%srcb;
  end
  endcase
 end
endmodule

