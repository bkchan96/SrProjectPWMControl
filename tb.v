`timescale 1ns / 1ps

module tb();
    reg clk, in;
    wire out;
    
    pwm u_pwm(clk, in, out);
    
    initial begin
        clk = 0;
        in = 0;
        #25000000
        in = 1;
        #25000000
        $finish;
    end
    
    always
        #10 clk = ~clk;
endmodule
