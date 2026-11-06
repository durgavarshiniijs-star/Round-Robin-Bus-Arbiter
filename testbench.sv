
`timescale 1ns/1ps

module testbench;

    reg clk;
    reg reset;
    reg [3:0] req;
    wire [3:0] grant;

    integer fairness_count;
    reg [3:0] fairness_seen;
    integer k;

    // DUT instantiation
    round_robin_arbiter uut (
        .clk(clk),
        .reset(reset),
        .req(req),
        .grant(grant)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Main stimulus
    initial begin

        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);

        clk = 0;
        reset = 1;
        req = 4'b0000;

        #10;
        reset = 0;

        // Test 1: Requester 0
        req = 4'b0001;
        #10;

        // Test 2: Requester 1
        req = 4'b0010;
        #10;

        // Test 3: All requesters
        req = 4'b1111;
        #40;

        // Test 4: Requester 2 and 3
        req = 4'b1100;
        #30;

        // Test 5: No requests
        req = 4'b0000;
        #20;

        // Test 6: Randomized Testing
        $display("--------------------------------");
        $display("Starting Randomized Testing");
        $display("--------------------------------");

        for (k = 0; k < 20; k = k + 1) begin
            @(negedge clk);
            req = $random;
        end

        // Stop all requests
        @(negedge clk);
        req = 4'b0000;

        #10;

        $display("--------------------------------");
        $display("Randomized Testing Completed");
        $display("Simulation completed.");
        $display("--------------------------------");

        $finish;

    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | Reset=%b | Req=%b | Grant=%b",
                  $time, reset, req, grant);
    end

    // Check mutual exclusion and idle condition
    always @(posedge clk) begin
        #1;

        if ((grant != 0) &&
            ((grant & (grant - 1'b1)) != 0))
            $display("ERROR: Multiple grants detected!");

        if (req == 0 && grant != 0)
            $display("ERROR: Invalid grant!");

    end

    // Initialize fairness checker
    initial begin
        fairness_count = 0;
        fairness_seen = 4'b0000;
    end

    // Fairness verification
    always @(posedge clk) begin
        #1;

        if (reset) begin
            fairness_count = 0;
            fairness_seen = 4'b0000;
        end

        else if (req == 4'b1111) begin

            if (grant != 4'b0000) begin

                fairness_seen = fairness_seen | grant;
                fairness_count = fairness_count + 1;

                if (fairness_count == 4) begin

                    if (fairness_seen == 4'b1111)
                        $display("PASS: Fairness verified!");

                    else
                        $display("FAIL: Fairness violation!");

                    fairness_count = 0;
                    fairness_seen = 4'b0000;

                end
            end
        end

        else begin
            fairness_count = 0;
            fairness_seen = 4'b0000;
        end
    end

endmodule
