`include "mux.v"

`ifndef TESTS
`define TESTS 32
`endif

module test;

    reg[31:0] data;
    reg[4:0] select;
    wire result;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        data = $random;
        $display("Data = %b", data);
        select = 0;
    end

    reg clk_reg = 1'b0;
    reg corr_res = 1'b0;
    wire clk;
    assign clk = clk_reg;

    mux #(.width(32), .channels(5)) uut(data, select, result);

    always #5 clk_reg <= ~clk_reg;

    always @(negedge clk) begin
        if (corr_res != result)
            $display("Incorrect result");
    end

    always @(posedge clk) begin
        select <= select + 1;
        #1 corr_res <= data[select];
        if (select >= `TESTS - 1)
            #10 $finish;
    end
endmodule
