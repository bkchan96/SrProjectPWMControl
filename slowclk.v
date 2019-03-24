`timescale 1ns / 1ps

module slowclk
    #(parameter system_clock = 100_000_000, target_freq = 50_000_000)
    (clk, reset, slowclk);
    input clk;
    input reset;
    output reg slowclk = 0;
    
    // compute counter value to generate slow clk
    localparam counter_max = system_clock/(2*target_freq);
    
    // declare register to hold counter value
    reg [27:0] counter = 0;  
    
    // run counter
    always @ (posedge clk)
    begin
        if (reset) begin
            counter <= 0;
            slowclk <= 0;
        end
        else begin
            counter = counter + 1;
            if (counter == counter_max) begin
                slowclk <= ~slowclk;
                counter <= 0;
            end
        end
    end
endmodule
