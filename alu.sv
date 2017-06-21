module alu (input logic [31:0] a,b,
	input logic [3:0] f, 
	input logic [4:0] shamt,	//added shamt
	output logic [31:0] y
	//output logic zero
	);	
always_comb
	case(f)	
	
	0: y = a&b;		
	1: y = a|b;
	2: y = a+b;
	3: y = 32'bZ; 
	4: y = a & ~b;
	5: y = a | ~b;	
	6: y = a-b;
	7: y = a<b? 1:0; //SLT added
	8: y = b<<shamt ;//SLL  added
	9: y = b>>shamt; //SRL  added
	
	default: y=32'bZ; 
	endcase	
	
	//assign zero = y==0? 1 : 0 ;
endmodule
