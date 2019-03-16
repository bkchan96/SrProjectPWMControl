`timescale 1ns / 1ps

module pwm (clk, duty_in, out);
    input clk;
    input [25:0] duty_in;
    output reg out;
    
    localparam rollover = 2000000;
    reg [25:0] counter;
    
    always @(posedge clk) begin
        if (counter == rollover)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    //original 240000 and 50000
    always @(counter) begin
        if (counter < duty_in)
            out <= 1;
        else
            out <= 0;
    end
    
endmodule
