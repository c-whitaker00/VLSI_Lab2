`timescale 1ns/10ps
module proc_tb;

reg clk;
localparam period = 5;

processor UUT (
.clk(clk)
);

initial 
    begin
        clk <= 0;
        forever #period clk = ~clk;
        #160;
    end

endmodule
