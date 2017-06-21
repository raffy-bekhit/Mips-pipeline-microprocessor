module datapath(input logic clk, reset,
input logic[1:0] memtoregE,memtoregM,memtoregW,
input logic pcsrcD, branchD,branchNOTD,
input logic alusrcE,
input logic [1:0] regdstE,
input logic regwriteE,regwriteM,regwriteW,
input logic jumpD,
input logic [3:0] alucontrolE,
output logic equalD,
output logic [31:0] pcF,
input logic [31:0] instrF,
output logic [31:0] aluoutM,writedataM,
input logic [31:0] readdatawordM, //edited from readdata , it is the word read from memory
output logic [5:0] opD, functD,
output logic flushE,
input logic loadbyteM,//added for lb
input logic jumpR, move_MUW //new
	);
logic forwardaD, forwardbD;
logic [1:0] forwardaE, forwardbE;
logic stallF;
logic [4:0] rsD, rtD, rdD, rsE, rtE, rdE;
logic [4:0] writeregE, writeregM, writeregW;
logic flushD;
logic [31:0] pcnextFD, pcnextbrFD,pcplus4F, pcbranchD;
logic [31:0] pcplus4E,pcplus4M,pcplus4W;
logic [31:0] signimmD, signimmE, signimmshD;
logic [31:0] srcaD, srca2D, srcaE, srca2E;
logic [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
logic [31:0] pcplus4D, instrD;
logic [31:0] aluoutE, aluoutW;
logic [31:0] readdataM,readdataW, resultW;   
logic [4:0]  shamtD, shamtE; //added
logic [31:0] pcnextFDbr,resultWbr; // new
logic [5:0] functE; //new
logic [31:0] outMUM,outMUW,outMUE;

// hazard detection
hazard h(rsD, rtD, rsE, rtE, writeregE, writeregM,writeregW,regwriteE, regwriteM, regwriteW,memtoregE, memtoregM, branchD,branchNOTD,
forwardaD, forwardbD, forwardaE,forwardbE,stallF, stallD, flushE);


// next PC logic (operates in fetch and decode)
mux2 #(32) pcbrmux(pcplus4F, pcbranchD, pcsrcD,pcnextbrFD);
mux2 #(32) pcmux(pcnextbrFD,{pcplus4D[31:28],instrD[25:0], 2'b00},jumpD, pcnextFDbr);
mux2 #(32) pcmux2(pcnextFDbr,srca2D,jumpR,pcnextFD);

// register file (operates in decode and writeback)
regfile rf(clk, regwriteW, rsD, rtD, writeregW,resultW, srcaD, srcbD);

// Fetch stage logic
flopenr #(32) pcreg(clk, reset, ~stallF,pcnextFD, pcF);
adder pcadd1(pcF, 32'b100, pcplus4F);

// Decode stage
flopenr #(32) r1D(clk, reset, ~stallD, pcplus4F,pcplus4D);
flopenrc #(32) r2D(clk, reset, ~stallD, flushD, instrF,instrD);
signext se(instrD[15:0], signimmD);
sl2 immsh(signimmD, signimmshD);
adder pcadd2(pcplus4D, signimmshD, pcbranchD);
mux2 #(32) forwardadmux(srcaD, aluoutM, forwardaD,srca2D);
mux2 #(32) forwardbdmux(srcbD, aluoutM, forwardbD,srcb2D);
eqcmp comp(srca2D, srcb2D, equalD);

assign opD = instrD[31:26];
assign functD = instrD[5:0];
assign rsD = instrD[25:21];
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
assign flushD = pcsrcD | jumpD | jumpR;	   //edited
assign shamtD = instrD[10:6];	 //added decoding shamt

// Execute stage
floprc #(32) r1E(clk, reset, flushE, srcaD, srcaE);
floprc #(32) r2E(clk, reset, flushE, srcbD, srcbE);
floprc #(32) r3E(clk, reset, flushE, signimmD, signimmE);
floprc #(5) r4E(clk, reset, flushE, rsD, rsE);
floprc #(5) r5E(clk, reset, flushE, rtD, rtE);
floprc #(5) r6E(clk, reset, flushE, rdD, rdE); 
floprc #(5) shamtToE(clk, reset, flushE, shamtD, shamtE);//added shamtD to shamtE
mux3 #(32) forwardaemux(srcaE, resultW, aluoutM,forwardaE, srca2E);
mux3 #(32) forwardbemux(srcbE, resultW, aluoutM,forwardbE, srcb2E);
mux2 #(32) srcbmux(srcb2E, signimmE, alusrcE,srcb3E);
alu alu(srca2E, srcb3E, alucontrolE,shamtE, aluoutE);	

//mux2 #(5) wrmux(rtE, rdE, regdstE, writeregE);
mux3 #(5) wrmux(rtE, rdE, 5'b11111 ,regdstE, writeregE);// new:instead of mux2 use mux3 (third option is for $ra address number 31/
floprc#(32) r7E(clk, reset, flushE, pcplus4D,pcplus4E); //new: save pc+4 to WB stage (add r7E,r4M,r4W)
floprc #(6) r8E(clk, reset, flushE, functD, functE);//new to save functD to excute stage
multiply mMU(clk,srca2E,srcb2E,functE,outMUE); //new multiply_unit

// Memory stage
flopr #(32) r1M(clk, reset, srcb2E, writedataM);
flopr #(32) r2M(clk, reset, aluoutE, aluoutM);
flopr #(5) r3M(clk, reset, writeregE, writeregM); 
flopr #(32) r4M(clk, reset, pcplus4E,pcplus4M); //new
flopr #(32) r5M(clk, reset, outMUE,outMUM);//new 
logic[7:0] readDataByteM;   //read byte from whichbyte multiplexer
logic[31:0] readDataByteSEM;   //read byte sign extended	

mux4 #(8) whichbyteM(readdatawordM[31:24],readdatawordM[23:16],readdatawordM[15:8],readdatawordM[7:0],aluoutM[1:0],readDataByteM);	 //choose which byte
signext8 rdataS(readDataByteM,readDataByteSEM)	 ;//sign extend read byte	 //added	
mux2 #(32) readdatafinal(readdatawordM,readDataByteSEM,loadbyteM,readdataM);	//readdata is byte or word read from memory //added		

// Writeback stage
flopr #(32) r1W(clk, reset, aluoutM, aluoutW);
flopr #(32) r2W(clk, reset, readdataM, readdataW);
flopr #(5) r3W(clk, reset, writeregM, writeregW);
flopr #(32) r4W(clk, reset, pcplus4M,pcplus4W); //new
flopr #(32) r5W(clk, reset, outMUM,outMUW); //new
mux3 #(32) resmux(aluoutW, readdataW,pcplus4W,memtoregW,resultWbr);// new:instead of mux2 use mux3 ($ra data (pc+4)
mux2 #(32) resmux2(resultWbr,outMUW,move_MUW,resultW); //new mux ,get result from muliply unit
//mux2 #(32) resmux(aluoutW, readdataW, memtoregW,resultW);
endmodule