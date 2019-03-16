`timescale 1ns / 1ps

module pwm (clk, duty_in, out);
    input clk;
    input [25:0] duty_in;
    output out;
    
    localparam rollover = 2000000;
    reg [25:0] counter = 0;
    
    always @(posedge clk) begin
        if (counter == rollover)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    //original 240000 and 50000
    assign out = (counter < duty_in) ? 1'b1 : 1'b0;
    
endmodule
