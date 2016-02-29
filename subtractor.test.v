`include "adder.v"

`ifndef TESTS
`define TESTS 10000
`endif

module test;

    reg [31:0] a, b, corr_res;
    reg cin;
    
    wire [31:0] result;
    wire cout;

    integer i;
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        cin = 1;
        i = 0;
    end

    adder uut(
        .i_a(a),
        .i_b(~b),
        .i_cin(cin),
        .o_result(result),
        .o_cout(cout)
    );
   
    wire clk;
    reg clk_reg = 1'b0;
    assign clk = clk_reg;

    always #5 clk_reg <= ~clk_reg;

    always @(negedge clk_reg) begin
        if (corr_res != result)
            $strobe("Strobe Incorrect Result! %d - %d = %d, correct = %d", a, b, result, corr_res);
    end
    
    always @(posedge clk_reg) begin
        a <= $random;
        b <= $random;
        #1 corr_res <= a-b;
        
        i = i + 1;
        if (i >= `TESTS)
            #10 $finish;
    end
endmodule
