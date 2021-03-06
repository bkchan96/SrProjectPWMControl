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


module LED_FSM(clk, hand, r, g, aud_out);
    input clk;
    input [1:0] hand;
    output reg r, g, aud_out;
    
    // declare slow clock signal
    wire slowclk;
    
    // instantiate a slow clk for state machine
    slowclk #(100_000_000, 100) u_slowclk(.clk(clk), .reset(), .slowclk(slowclk));
    
    // declare state types and state registers
    parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101, s6 = 3'b110;
    reg [2:0] PS = s0, NS;
    
    // declare counter
    reg [28:0] counter = 0;
    reg counter_rst;
    
    // counter for FSM
    always @(posedge slowclk) begin
        if (counter_rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end
    
    // flip flops for FSM
    always @ (posedge slowclk) begin
        PS <= NS;
    end
    
    // instantiate frequencies for audio output
    wire freq730, freq950;
    slowclk #(100_000_000, 730) u_slowclk_730(.clk(clk), .reset(), .slowclk(freq730));
    slowclk #(100_000_000, 950) u_slowclk_950(.clk(clk), .reset(), .slowclk(freq950));
    
    // combinational logic for Moore FSM
    always @* begin
        case (PS)
            s0: begin
                counter_rst = 1;
                r = 1'b1;
                g = 1'b0;
                aud_out = 1'b0;
                if (hand == 2'b11)
                    NS = s1;
                else
                    NS = s0;
            end
            s1: begin
                counter_rst = 1;
                r = 1'b0;
                g = 1'b0;
                aud_out = freq730;
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
                aud_out = 1'b0;
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
                aud_out = freq730;
                if (hand == 2'b11)
                    NS = s3;
                else
                    NS = s4;
            end  
            s4: begin
                counter_rst = 0;
                r = 1'b1;
                g = 1'b0;
                aud_out = 1'b0;
                if (counter == 50)
                    NS = s5;
                else
                    NS = s4;
            end
            s5: begin
                counter_rst = 1;
                r = 1'b1;
                g = 1'b0;
                aud_out = 1'b0;
                NS = s6;
            end
            s6: begin
                counter_rst = 0;
                r = 1'b0;
                g = 1'b1;
                aud_out = freq950;
                if (counter == 300)
                    NS = s0;
                else
                    NS = s6;
            end  
        endcase
    end

endmodule
