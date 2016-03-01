`ifndef ALU_V
`define ALU_V

`include "adder.v"
`include "multiplier.v"
`include "divider.v"
`include "shifter.v"

`define OP_NOP          4'h0
`define OP_ADD          4'h1
`define OP_SUB          4'h2
`define OP_MUL          4'h3
`define OP_DIV          4'h4
`define OP_LEFT_SHIFTL  4'h5
`define OP_LEFT_SHIFTA  4'h6
`define OP_RIGHT_SHIFTL 4'h7
`define OP_RIGHT_SHIFTA 4'h8

// Simple single cycle adder
module alu(
  input clk,
  input reset,
  
  input [31:0] i_a,    // 1st operand
  input [31:0] i_b,    // 2nd operand
  input  [3:0] i_cmd,  // command

  output [31:0] o_result,
  output        o_valid, // result is valid

  output        o_ready  // ready to take input
);

reg [31:0] reg_result;
reg        reg_valid = 1'b0;

// ALU state machine macros
`define ST_RESET  2'h0
`define ST_READY  2'h1
`define ST_BUSY   2'h2

// begin in reset state
reg [1:0] reg_status = `ST_RESET;

// Synchronous reset
always @(posedge clk && reset) begin
  reg_status <= `ST_READY;
end

// Assign outputs
assign o_ready = ((reg_status == `ST_READY) && !reset);
assign o_valid = (reg_valid && (reg_status == `ST_READY));
assign o_result = reg_result; //o_valid ? reg_result : 32'hx; // Ternary operator

// instants of various components of alu

// Adder
reg adder_cin;
wire adder_cout;
wire[31:0] adder_result;
adder alu_adder(.i_a(i_a), .i_b(i_b), .i_cin(adder_cin), .o_result(adder_result), .o_cout(adder_cout));

// Subtractor
reg subtractor_cin;
wire subtractor_cout;
wire[31:0] subtractor_result;
adder alu_subtractor(.i_a(i_a), .i_b(~i_b), .i_cin(subtractor_cin), .o_result(subtractor_result), .o_cout(subtractor_cout));

// Multiplier
reg multiplier_start = 1'b0;
wire[`WIDTH + `WIDTH - 1:0] multiplier_result;
wire multiplier_ready;

multiplier mul(
    .start(multiplier_start),
    .clk(clk),
    .multiplier(i_a),
    .multiplicand(i_b),
    .product(multiplier_result),
    .ready(multiplier_ready));

// Divider
reg divider_start = 1'b0;
wire[`WIDTH-1:0] divider_quotient, divider_remainder;
wire divider_ready;

divider div(
    .start(divider_start),
    .clk(clk),
    .dividend(i_b),
    .divisor(i_a),
    .quotient(divider_quotient),
    .remainder(divider_remainder),
    .ready(divider_ready));

// Shifter
reg[`OPS-1:0] shifter_ops;
wire[`WIDTH-1:0] shifter_result;
reg shifter_start = 1'b0;

shifter shift(
    .i_data(i_a),
    .i_shift(i_b[`SHIFT_WIDTH-1:0]),
    .i_op(shifter_ops),
    .i_start(shifter_start),
    .o_result(shifter_result));

// Main processing loop
always @(posedge clk && !reset) begin

  case (reg_status)
  `ST_READY: begin
    reg_status <= `ST_BUSY;
    case (i_cmd)
        `OP_ADD: begin
            adder_cin = 1'b0;
            reg_result = adder_result;
        end

        `OP_SUB: begin
            subtractor_cin = 1'b1;
            reg_result = subtractor_result;
        end

        `OP_MUL: begin
            multiplier_start = 1'b1;
            reg_result = multiplier_result[`WIDTH-1:0];
        end

        `OP_DIV: begin
            divider_start = 1'b1;
            reg_result = divider_quotient;
        end

        `OP_LEFT_SHIFTL: begin
            shifter_ops = `LEFT_SHIFTL;
            shifter_start = 1'b1;
            reg_result = shifter_result;
        end

        `OP_LEFT_SHIFTA: begin
            shifter_ops = `LEFT_SHIFTA;
            shifter_start = 1'b1;
            reg_result = shifter_result;
        end

        `OP_RIGHT_SHIFTL: begin
            shifter_ops = `RIGHT_SHIFTL;
            shifter_start = 1'b1;
            reg_result = shifter_result;
        end

        `OP_RIGHT_SHIFTA: begin
            shifter_ops = `RIGHT_SHIFTA;
            shifter_start = 1'b1;
            reg_result = shifter_result;
        end
    endcase
  end
  `ST_BUSY: begin
    if (divider_ready == 1'b1 && multiplier_ready == 1'b1) begin
        reg_valid <= 1'b1;
        reg_status <= `ST_READY;
    end

    shifter_start = 1'b0;
    if (divider_ready == 1'b0)
        divider_start = 1'b0;
    
    if (multiplier_ready == 1'b0)
        multiplier_start = 1'b0;
  end
  default: begin
    $display("should not happen");
    $finish;
  end
  endcase

end

endmodule

`endif
