`ifndef ADDER_V
`define ADDER_v
`include "full_adder.v"

// 32-bit adder
module adder(
    input [31:0] i_a,
    input [31:0] i_b,
    input i_cin,
    output [31:0 ] o_result,
    output o_cout);

    wire [32:0] ripple;
    assign ripple[0] = i_cin;
    assign o_cout = ripple[32];

    genvar i;

    // Generate 32 full adders
    generate
    for (i = 0; i < 32; i = i + 1)
        full_adder fa(
            .i_a(i_a[i]),
            .i_b(i_b[i]),
            .i_cin(ripple[i]),
            .o_result(o_result[i]),
            .o_cout(ripple[i+1])
        );
    endgenerate

endmodule
`endif
