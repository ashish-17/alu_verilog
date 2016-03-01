`ifndef MULTIPLIER_V
`define MULTIPLIER_V

`ifndef WIDTH
`define WIDTH 32
`endif

module multiplier(
    input start,
    input clk,
    input [`WIDTH - 1:0] multiplier,
    input [`WIDTH - 1:0] multiplicand,
    output reg [`WIDTH + `WIDTH - 1:0] product,
    output ready);

    reg[`WIDTH - 1:0] multiplier_copy;
    reg[`WIDTH + `WIDTH - 1:0] multiplicand_copy;
    reg[4:0] bits;

    assign ready = !bits;

    initial begin
       bits = 0;
    end

    // Repititive addition
    always @(posedge clk) begin
        if (ready & start) begin
            bits = `WIDTH;
            product = 0;
            multiplicand_copy = {`WIDTH'd0, multiplicand};
            multiplier_copy = multiplier;
        end
        else if (bits) begin
            if (multiplier_copy[0] == 1'b1)
                product = product + multiplicand_copy;

            multiplier_copy = multiplier_copy >> 1;
            multiplicand_copy = multiplicand_copy << 1;

            bits = bits - 1;
        end
    end
endmodule
`endif
