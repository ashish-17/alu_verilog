`include "alu.v"
`include "sim.v"

`define TESTS_ADDER 100
`define TESTS_SUBTRACTOR 100
`define TESTS 200

module test();

wire reset;
wire clk;

// Connecting wires
wire [31:0] alu_a;
wire [31:0] alu_b;
wire [3:0] alu_cmd;

wire [31:0] alu_result;
wire        alu_res_valid;
wire        alu_ready;

// You can use arrays (even multidimensional
reg [32+32-1:0] tests [0:`TESTS-1];
reg done = 1'b0;

// This is not synthetizable
integer i;
integer tmp;

reg [31:0] t = 5'h0;

reg [31:0] a,b,res;
reg [3:0] op = `OP_NOP;

assign alu_a   = a;
assign alu_b   = b;
assign alu_cmd = op;

// Initial block
initial begin
  for(i = 0; i < `TESTS; i = i + 1) begin
      tmp = $random % 32;
      tests[i] <= {{$random},{tmp}};
  end
   op <= `OP_LEFT_SHIFTL;
end

always @(posedge alu_res_valid) begin
  if (alu_result != res)
    $display("Result wrong!");
end

always @(posedge alu_ready) begin
   a <= tests[t][63:32];
   b <= tests[t][31:0];
   res <= tests[t][63:32] << tests[t][31:0];
   if (t + 1 < `TESTS)
     t = t + 1;
   else begin
     //finish here?
     t = 0;
     done = 1'b1;
   end
end


// ALU module
alu my_alu
(
  .clk(clk),
  .reset(reset),

  .i_a(alu_a),
  .i_b(alu_b),
  .i_cmd(alu_cmd),

  .o_result(alu_result),
  .o_valid(alu_res_valid),
  .o_ready(alu_ready)
);

// Simulator (clock + reset)
sim my_sim(
  .clk(clk),
  .reset(reset)
);

endmodule
