module testbench();
 logic clk;
 logic reset;
 logic [31:0] writedata, dataadr;
 logic memwrite;
 // instantiate device to be tested
 top dut(clk, reset, writedata, dataadr, memwrite,savebyteM);
 // initialize test
 initial
 begin
 reset <= 1; # 22; reset <= 0;
 end
 // generate clock to sequence tests
 always
 begin
 clk <= 1; # 5; clk <= 0; # 5;
 end
 // check results
 always @(negedge clk)
 begin
 if(memwrite) begin
 if(dataadr === 12 & writedata === 32'h0000003F) begin
 $display("Simulation succeeded");
 $stop;
 end
 
 end
 end
endmodule