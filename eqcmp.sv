module eqcmp(
	input logic [31:0] a,b,
	output logic y
	)	;
always_comb
begin
if(a==b) assign y=1;
else assign y=0; 	  
	
	end
	endmodule