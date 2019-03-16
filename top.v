`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2019 12:20:41 PM
// Design Name: 
// Module Name: top
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


module top(clk, manual_on, sw, rpi, out, outc, outan, dp);
    input clk, manual_on;
    input [1:0] sw;
    input [1:0] rpi;
    output [2:0] out;
    output [6:0] outc;
    output [7:0] outan;
    output dp;
    
    // decode input from raspberry pi
    reg [25:0] duty0, duty1, duty2;
    wire [1:0] decode;
    
    // multiplex input from either rpi or manual switches
    assign decode = (manual_on) ? sw : rpi;
    
    // decode input
    always @(decode) begin
        case (decode)
            2'b00: begin duty0 = 100000; duty1 = 145000; duty2 = 145000; end
            2'b01: begin duty0 = 50000;  duty1 = 50000;  duty2 = 50000;  end
            2'b10: begin duty0 = 100000; duty1 = 50000;  duty2 = 145000; end
            2'b11: begin duty0 = 75000;  duty1 = 97500;  duty2 = 97500;  end
        endcase
    end
    
    // instantiate pwm generators
    pwm u_pwm_0(.clk(clk), .duty_in(duty0), .out(out[0]));      //#(100000)
    pwm u_pwm_1(.clk(clk), .duty_in(duty1), .out(out[1]));      //#(145000)
    pwm u_pwm_2(.clk(clk), .duty_in(duty2), .out(out[2]));      //#(145000)
    
    // create logic to drive 7 segment display to reflect data being sent from rpi
    reg [3:0] in0, in1, in2, in3, in4, in5, in6, in7;
    
    always @(rpi) begin
        case (rpi)
            2'b00: begin //rock ("rocc")
                in7 = 4; in6 = 3; in5 = 1; in4 = 1;
                in3 = 9; in2 = 9; in1 = 9; in0 = 9;
            end
            2'b01: begin //paper
                in7 = 5; in6 = 6; in5 = 5; in4 = 7;
                in3 = 4; in2 = 9; in1 = 9; in0 = 9;
            end
            2'b10: begin //scissors
                in7 = 0; in6 = 1; in5 = 2; in4 = 0;
                in3 = 0; in2 = 3; in1 = 4; in0 = 0;
            end
            2'b11: begin //none
                in7 = 8; in6 = 3; in5 = 8; in4 = 7;
                in3 = 9; in2 = 9; in1 = 9; in0 = 9;
            end
        endcase
    end
    
    // instantiate 7 segment display driver
    displayController u_display_controller(
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .out(outc),
        .outan(outan));
    
    // disable decimal point
    assign dp = 1'b1;
    
endmodule
