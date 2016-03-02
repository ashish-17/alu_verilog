`ifndef SHIFTER_V
`define SHIFTER_V

`include "mux.v"

`ifndef WIDTH
`define WIDTH 32
`endif

`ifndef SHIFT_WIDTH
`define SHIFT_WIDTH 5
`endif

`ifndef OPS
`define OPS 2
`endif

`define LEFT_SHIFTA 2'b00
`define LEFT_SHIFTL 2'b01
`define RIGHT_SHIFTA 2'b10
`define RIGHT_SHIFTL 2'b11

module shifter(
    input[`WIDTH - 1:0] i_data,
    input[`SHIFT_WIDTH - 1:0] i_shift,
    input[`OPS - 1:0] i_op,
    input i_start,
    output[`WIDTH - 1:0] o_result);
    
    reg[`WIDTH - 1:0] zeroes;
    reg[`WIDTH - 1:0] ones;
    reg[`WIDTH - 1:0] result;

    initial begin
        zeroes = 0;
        ones = ~0;
    end

    wire[`WIDTH - 1: 0] left;
    wire[`WIDTH - 1: 0] right;
    wire[`WIDTH - 1: 0] rightA;

    assign o_result = result;
    
    genvar i;

    generate
        for (i = 0; i < `WIDTH; i = i + 1) begin
            if (i == 0)
                mux #(.width(`WIDTH), .channels(`WIDTH)) m(i_data, `WIDTH - i_shift - 1, left[`WIDTH - i - 1]);
            else
                mux #(.width(`WIDTH), .channels(`WIDTH)) m({i_data[`WIDTH - 1 - i:0], zeroes[i - 1:0]}, `WIDTH - 1 - i_shift, left[`WIDTH - i - 1]);

            if (i == 0) 
                mux #(.width(`WIDTH), .channels(`SHIFT_WIDTH)) m(i_data, i_shift, right[i]);
            else 
                mux #(.width(`WIDTH), .channels(`SHIFT_WIDTH)) m({zeroes[i-1:0], i_data[`WIDTH-1:i]}, i_shift, right[i]);
            
            if (i == 0) 
                mux #(.width(`WIDTH), .channels(`SHIFT_WIDTH)) m(i_data, i_shift, rightA[i]);
            else
                mux #(.width(`WIDTH), .channels(`SHIFT_WIDTH)) m({ones[i-1:0], i_data[`WIDTH-1:i]}, i_shift, rightA[i]);
        end
    endgenerate

    always @* begin
        if (i_start) begin
            case (i_op)
                `LEFT_SHIFTA: result <= left;
                `LEFT_SHIFTL: result <= left;
                `RIGHT_SHIFTA: result <= i_data[`WIDTH-1] == 1'b1 ? rightA : right;
                `RIGHT_SHIFTL: result <= right;
                default: $display("Error!");
            endcase
        end
    end
endmodule
`endif
