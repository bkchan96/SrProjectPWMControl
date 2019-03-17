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


module top(clk, manual_on, sw, rpi, out, r, g);
    input clk, manual_on;
    input [1:0] sw;
    input [1:0] rpi;
    output r, g;
    output [2:0] out;
    
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
    
    LED_FSM u_LED_FSM(.clk(clk), .hand(rpi), .r(r), .g(g));
    
endmodule
