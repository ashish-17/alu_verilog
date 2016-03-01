`ifndef DIVIDER_V
`define DIVIDER_V

`ifndef WIDTH
`define WIDTH 32
`endif

module divider(
    input start,
    input clk,
    input [`WIDTH-1:0] dividend,
    input [`WIDTH-1:0] divisor,
    output reg [`WIDTH-1:0] quotient,
    output [`WIDTH-1:0] remainder,
    output ready);

    reg [`WIDTH+`WIDTH-1:0] dividend_copy, divisor_copy, diff;
    assign remainder = dividend_copy[`WIDTH-1:0];
    reg [4:0] bits;
    assign ready = !bits;
    
    initial begin
        bits = 0;
    end

    // Division by repeated subtraction
    always @ (posedge clk) begin
        if (ready & start) begin
            bits = `WIDTH;
            quotient = 0;
            dividend_copy = {`WIDTH'd0, dividend};
            divisor_copy = {1'b0, divisor, 31'd0};
        end
        else if (bits) begin
            diff = dividend_copy - divisor_copy;
            quotient = quotient << 1;

            if (!diff[`WIDTH+`WIDTH-1]) begin
                dividend_copy = diff;
                quotient[0] = 1'd1;
            end

            divisor_copy = divisor_copy >> 1;
            bits = bits - 1;
        end
    end

endmodule
`endif
