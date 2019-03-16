`timescale 1ns / 1ps

module displayController(clk, in0, in1, in2, in3, in4, in5, in6, in7, out, outan);
    input clk;
    input [6:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output reg [6:0] out;
    output reg [7:0] outan;
    
    reg [3:0] anode = 0;
    reg [17:0] counter;
    
    initial begin
        outan = 0;
        out = 0;
        counter = 0;
    end
    
    always@ (posedge clk)
    begin
        //250,000 for 400hz
        //lower is faster and less flicker
        if (counter == 100000) begin
            counter = 0;
            if (anode == 7) begin
                anode = 0;
            end
            else begin
                anode = anode + 1;
            end
        end
        else begin
            counter = counter + 1;
        end
    end
    
    always @*
    begin
        case (anode)
            0: begin
                outan = 8'b11111110;
                out = in0;
            end
            1: begin
                outan = 8'b11111101;
                out = in1;
            end
            2: begin
                outan = 8'b11111011;
                out = in2;
            end
            3: begin
                outan = 8'b11110111;
                out = in3;
            end
            4: begin
                outan = 8'b11101111;
                out = in4;
            end
            5: begin
                outan = 8'b11011111;
                out = in5;
            end
            6: begin
                outan = 8'b10111111;
                out = in6;
            end
            7: begin
                outan = 8'b01111111;
                out = in7;
            end
            default: begin
                outan = 8'b11111111;
                out = 7'b1111111;
            end
        endcase
    end
endmodule
