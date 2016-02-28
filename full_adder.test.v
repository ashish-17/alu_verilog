`include "full_adder.v"

`ifndef TESTS
`define TESTS 8
`endif

module test;

    // Inputs
    reg a;
    reg b;
    reg cin;

    // Outputs
    wire result;
    wire cout;

    integer i;

    // Instantiate the FA module
    full_adder uut(
        .i_a(a),
        .i_b(b),
        .i_cin(cin),
        .o_result(result),
        .o_cout(cout)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        a = 0;
        b = 0;
        cin = 0;
    end

    always @ (a, b, cin)
    begin
        for (i = 0; i < `TESTS; i = i+1)
            #10 {a,b,cin} = i; // Set a,b,cin to binary representation of i

        #10 $finish;
    end
endmodule
