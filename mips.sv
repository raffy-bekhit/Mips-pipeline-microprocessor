// pipelined MIPS processor
module mips(input logic clk, reset,
output logic [31:0] pcF,
input logic [31:0] instrF,
output logic memwriteM,
output logic [31:0] aluoutM, writedataM,
input logic [31:0] readdataM  ,
output logic savebyteM
);
logic [5:0] opD, functD;
logic [1:0] regdstE;
logic alusrcE,pcsrcD;
logic [1:0]memtoregE, memtoregM, memtoregW;
logic loadbyteM,			   //added
regwriteE, regwriteM, regwriteW;
logic [3:0] alucontrolE;
logic flushE, equalD;
logic jumpR,move_MUW;
logic branchNOTD,branchD;  

controller c(clk, reset, opD, functD, flushE,equalD,memtoregE, memtoregM,memtoregW, memwriteM, pcsrcD,
branchD,alusrcE,branchNOTD, regdstE, regwriteE,regwriteM, regwriteW, jumpD,alucontrolE,loadbyteM,savebyteM,jumpR,move_MUW);	   //added


datapath dp(clk, reset, memtoregE, memtoregM,memtoregW, pcsrcD, branchD,branchNOTD,alusrcE, regdstE, regwriteE,
regwriteM, regwriteW, jumpD,alucontrolE,equalD, pcF, instrF,aluoutM, writedataM, readdataM,
opD, functD, flushE,loadbyteM,jumpR,move_MUW );	//added
endmodule