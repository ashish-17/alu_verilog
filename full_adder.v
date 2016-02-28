`ifndef FULL_ADDER_V
`define FULL_ADDER_V

// 1 bit full adder
module full_adder(
    input i_a,
    input i_b,
    input i_cin,
    output o_result,
    output o_cout);

    assign o_result = i_a ^ i_b ^ i_cin;
    assign o_cout = (i_a & i_b) | (i_a & i_cin) | (i_b & i_cin);
endmodule

`endif
