`include "mux.v"

`ifndef WIDTH
`define WIDTH 16
`endif

`ifndef CHANNELS
`define CHANNELS 4
`endif

module test;

    reg[`WIDTH-1:0] data;
    reg[`CHANNELS-1:0] select;
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

    mux #(.width(`WIDTH), .channels(`CHANNELS)) uut(data, select, result);

    always #5 clk_reg <= ~clk_reg;

    always @(negedge clk) begin
        if (corr_res != result)
            $display("Incorrect result");
    end

    always @(posedge clk) begin
        select <= select + 1;
        #1 corr_res <= data[select];
        if (select >= `WIDTH - 1)
            #10 $finish;
    end
endmodule
