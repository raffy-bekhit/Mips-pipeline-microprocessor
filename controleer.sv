module controller(input logic clk, reset,
input logic [5:0] opD, functD,
input logic flushE, equalD,
output logic [1:0] memtoregE,memtoregM, memtoregW,
output logic memwriteM,
output logic pcsrcD,branchD, alusrcE,branchNOTD,
output logic [1:0] regdstE,
output logic regwriteE,
output logic regwriteM,regwriteW,
output logic jumpD,
output logic [3:0] alucontrolE	,
output logic loadbyteM,	//added
output logic savebyteM, //added
output logic jumpR,move_MUW);


logic [1:0] aluopD;
logic [1:0] memtoregD;
logic memwriteD, alusrcD;
logic [1:0] regdstD;
logic  regwriteD;
logic loadbyteD,loadbyteE;//added for lb   
logic savebyteD,savebyteE;	
logic [3:0] alucontrolD;
logic memwriteE;
logic move_MUE,move_MUM,move_MUD;
maindec md(opD, memtoregD, memwriteD, branchD,alusrcD, regdstD, regwriteD, jumpD,aluopD,loadbyteD,savebyteD,branchNOTD);
aludec ad(functD, aluopD, alucontrolD);

//assign pcsrcD = (branchD & equalD)||(branchNOTD & ~equalD);

always_comb //new
begin
  if(branchD & equalD )
    pcsrcD =1'b1;
  else if (branchNOTD & !equalD)
     pcsrcD =1'b1;
     else pcsrcD =0'b0;
end

always_comb //new
begin
  begin
  if(functD===6'b001000)
    jumpR=1;
  else jumpR=0;
  end
   begin 
   if(functD==6'b010000)//if mflo or mfhi
      move_MUD=1;
     else if(functD==6'b010010)
     move_MUD=1; 
     else move_MUD=0;
end
end

// pipeline registers
floprc #(14) regE(clk, reset, flushE,{memtoregD, memwriteD, alusrcD,regdstD, regwriteD, alucontrolD,loadbyteD,savebyteD,move_MUD},
{memtoregE, memwriteE, alusrcE,regdstE, regwriteE, alucontrolE,loadbyteE,savebyteE,move_MUE});
flopr #(7) regM(clk, reset,{memtoregE, memwriteE, regwriteE,loadbyteE,savebyteE,move_MUE},{memtoregM, memwriteM, regwriteM,loadbyteM,savebyteM,move_MUM});
flopr #(4) regW(clk, reset,{memtoregM, regwriteM,move_MUM},{memtoregW, regwriteW,move_MUW});
endmodule