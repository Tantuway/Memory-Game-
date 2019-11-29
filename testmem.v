`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2019 17:44:38
// Design Name: 
// Module Name: testmem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testmem;

    reg [3:0] predict;
    reg clk;
    reg startIN;
    reg loadIN;
    reg reset;
    wire [7:0] led;
    
    memgame DUT ( .predict(predict), .clk(clk), .startIN(startIN), .loadIN(loadIN), .led(led));
   
    initial 
        begin 
            $monitor ($time, " predict=%d, clk=%b, startIN=%b, loadIN=%b, led=%d", predict, clk, startIN, loadIN, led);
        $dumpfile("test.vcd");
        $dumpvars(0,DUT);
        predict = 4'b0000;
        clk = 1'b0;
        startIN = 1'b0;
        loadIN = 1'b0;
     
        
        
        #130 startIN = 1'b1;
        #10000 predict = 4'b1000;
        #10 loadIN =1'b1;
        #10 loadIN =1'b0;
        #20 predict = 4'b0111;
        #10 loadIN =1'b1;
        #10 loadIN =1'b0;
        #20 predict = 4'b0000;
        #10 loadIN =1'b1;
        #10 loadIN =1'b0;
        #2000 
        #10 loadIN =1'b1;
        #10 loadIN =1'b0;
        #100000 $finish;
        
        
        end 
        
    always #5 clk = ~clk;

endmodule
