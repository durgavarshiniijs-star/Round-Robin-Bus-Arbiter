// Code your design here
`timescale 1ns/1ps
module round_robin_arbiter (
    input clk,
    input reset,
    input [3:0] req,
    output reg [3:0] grant
);

    reg [1:0] priority_ptr;
    reg [1:0] next_ptr;
    integer i;
    reg found;

    always @(*) begin
        grant = 4'b0000;
        next_ptr = priority_ptr;
        found = 1'b0;

        for (i = 0; i < 4; i = i + 1) begin
            if (!found && req[(priority_ptr + i) % 4]) begin
                grant[(priority_ptr + i) % 4] = 1'b1;
                next_ptr = ((priority_ptr + i) % 4 + 1) % 4;
                found = 1'b1;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            priority_ptr <= 2'd0;
        end
        else if (|grant) begin
            priority_ptr <= next_ptr;
        end
    end

endmodule
