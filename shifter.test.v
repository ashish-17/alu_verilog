`include "shifter.v"

`ifndef TESTS
`define TESTS 32
`endif

module test;

    reg[`WIDTH-1:0] data;
    reg[`SHIFT_WIDTH-1:0] shift;
    reg[`OPS-1:0] op;
    wire[`WIDTH-1:0] result;
    reg[`WIDTH-1:0] corr_result;
    reg[`WIDTH-1:0] test_vals[0:`TESTS-1];
    reg[`SHIFT_WIDTH-1:0] test_shifts[0:`TESTS-1];
    reg start;
    
    reg[`WIDTH-1:0] tests;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        data = $random;
        op = 2'b11;
        for (tests = 0; tests < `TESTS; ++tests) begin
            test_vals[tests] = $random;//32'b10000000000000000000000000000000;
            test_shifts[tests] = 5'b00101;
        end

        data = 0;
        shift = test_shifts[0];
        tests = 0;
        start = 1'b1;
    end

    reg clk_reg = 1'b0;
    wire clk;
    assign clk = clk_reg;

    always #5 clk_reg <= ~clk_reg;

    shifter uut(data, shift, op, start, result);

    always @(negedge clk) begin
        case (op)
            `LEFT_SHIFTA: corr_result = $signed(test_vals[tests]) <<< test_shifts[tests];
            `LEFT_SHIFTL: corr_result = test_vals[tests] << test_shifts[tests];
            `RIGHT_SHIFTA: corr_result = $signed(test_vals[tests]) >>> test_shifts[tests];
            `RIGHT_SHIFTL: corr_result = test_vals[tests] >> test_shifts[tests];
            default: $display("Invalid op");
        endcase

        if (corr_result != result)
            $display("Invalid result : expected - %d, got - %d", corr_result, result);
    end

    always @(posedge clk) begin
        tests <= tests + 1;
        data <= test_vals[tests];
        //shift <= test_shifts[tests];
        if (tests >= `TESTS-1)
            #10 $finish;
    end
endmodule
