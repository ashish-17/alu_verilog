`include "adder.v"

`ifndef TESTS
`define TESTS 100
`endif

module test;

    reg [32+32-1:0] tests[0:`TESTS];
    
    reg [31:0] a, b, corr_res;
    reg cin;
    
    wire [31:0] result;
    wire cout;

    integer i = 0;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        cin = 0;
        for (i = 0; i < `TESTS; i = i + 1) begin
            a = $unsigned($random) % 100;
            b = $unsigned($random) % 100;
            corr_res = a+b;
            if (corr_res != result)
                $display("Incorrect Result! %d + %d = %d, correct = %d", a, b, corr_res, result);
        end

        #10 $finish;
    end

    adder uut(
        .i_a(a),
        .i_b(b),
        .i_cin(cin),
        .o_result(result),
        .o_cout(cout)
    );

endmodule
