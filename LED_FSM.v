`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/16/2019 04:54:07 PM
// Design Name: 
// Module Name: LED_FSM
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


module LED_FSM(clk, hand, r, g);
    input clk;
    input [1:0] hand;
    output reg r, g;
    
    // declare state types and state registers
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100;
    reg [2:0] PS = s0, NS;
    
    // declare counter
    reg [28:0] counter = 0;
    reg counter_rst;
    
    //flip flops of FSM
    always @(posedge clk) begin
        PS <= NS;
        if (counter_rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    always @* begin
        case (PS)
            s0: begin
                counter_rst = 1;
                r = 1'b1;
                g = 1'b0;
                if (hand == 2'b11)
                    NS = s1;
                else
                    NS = s0;
            end
            s1: begin
                counter_rst = 1;
                r = 1'b0;
                g = 1'b0;
                if (hand == 2'b11)
                    NS = s1;
                else if (hand == 2'b01)
                    NS = s2;
                else
                    NS = s1;
            end      
            s2: begin
                counter_rst = 1;
                r = 1'b1;
                g = 1'b0;
                if (hand == 2'b11)
                    NS = s3;
                else if (hand == 2'b01)
                    NS = s2;
                else
                    NS = s2;
            end      
            s3: begin
                counter_rst = 1;
                r = 1'b0;
                g = 1'b0;
                if (hand == 2'b11)
                    NS = s3;
                else
                    NS = s4;
            end      
            s4: begin
                counter_rst = 0;
                r = 1'b0;
                g = 1'b1;
                if (counter == 300_000_000)
                    NS = s0;
                else
                    NS = s4;
            end  
        endcase
    end

endmodule
