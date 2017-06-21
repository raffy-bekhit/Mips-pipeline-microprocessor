module maindec(input logic [5:0] op,
output logic [1:0]memtoreg, 
output logic memwrite,
output logic branch, alusrc,
output logic [1:0]regdst,
output logic regwrite,
output logic jump,
output logic [1:0] aluop,
output logic loadbyte,  //added //to determine read byte or word from memory
output logic savebyte  // added //to determine save byt or word
,branchNOT);
logic [13:0] controls;
assign {regwrite, regdst, alusrc,branch, memwrite,memtoreg, jump, aluop,loadbyte,savebyte,branchNOT} = controls;
always_comb
case(op)
6'b000000: controls <= 14'b1_01_0_0_0_00_0_11_0_0_0; //Rtyp 
6'b100011: controls <= 14'b1_00_1_0_0_01_0_00_0_0_0; //LW
6'b100000: controls <= 14'b1_00_1_0_0_01_0_00_1_0_0; //LB	  //added
6'b101011: controls <= 14'b0_00_1_0_1_00_0_00_0_0_0; //SW
6'b101000: controls <= 14'b0_00_1_0_1_00_0_00_0_1_0; //SB   //added
6'b000100: controls <= 14'b0_00_0_1_0_00_0_01_0_0_0; //BEQ
6'b000101: controls <= 14'b0_00_0_0_0_00_0_01_0_0_1; //BNE  //added
6'b001000: controls <= 14'b1_00_1_0_0_00_0_00_0_0_0; //ADDI
6'b000010: controls <= 14'b0_00_0_0_0_00_1_00_0_0_0; //J 
6'b000011: controls <= 14'b1_10_0_0_0_10_1_00_0_0_0; //JAL 
6'b001010: controls <= 14'b1_00_1_0_0_00_0_10_0_0_0; //SLTI
default: controls   <= 14'bxxxxxxxxxxxxxx; //???
endcase
endmodule