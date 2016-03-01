`include "multiplier.v"
`include "sim.v"

`define TESTS 5

module test;

    reg[`WIDTH-1:0] a, b;
    reg[`WIDTH+`WIDTH-1:0] result, corr_result;
    wire[`WIDTH+`WIDTH-1:0] out;
    reg start = 1'b0;
    reg next_reg = 1'b0;

    wire clk, reset, ready, next;
    assign next = next_reg;
    
    integer t;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        #10 start = 1'b1;
        a = $random % 10;
        b = $random % 10;
        t = 0;
    end

    always @(posedge ready) begin
        $display("Result = %d, exp = %d", out, corr_result);
        start <= 1'b0;
        #10 next_reg<= 1'b1;
    end

    always @(posedge next) begin
        a <= $random % 10;
        b <= $random % 10;
        #10 next_reg <= 1'b0;
        #1 corr_result <= a*b;
        #1 start <= 1'b1;

        t = t+1;
        if (t >= `TESTS-1)
            #10 $finish;
    end
            
    multiplier mul(
        .start(start),
        .clk(clk),
        .multiplier(b),
        .multiplicand(a),
        .product(out),
        .ready(ready));

    sim my_sim(.clk(clk), .reset(reset));
endmodule
