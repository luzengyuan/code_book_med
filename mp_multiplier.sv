//Implement a pipelined multiplier.
//3-stage pipeline


module mp_multiplier#(
parameter W = 32
)
(
input logic clk,
input logic resetn,

input logic valid_in,
input logic [W-1:0] a,
input logic [W-1:0] b,

output logic valid_out,
output logic[W+W-1:0] out_result
);

//stage1  ---> stage 2 ---> stage3
//input reg --> partial ---> output reg


logic [W-1:0] a1, b1;
logic [2W-1:0] mult;
logic v1,v2;

always_ff @(posedge clk) begin
    a1 <= a;
    b1 <= b;
    v1<= valid_in;
end

always_ff @(posedge clk) begin
    mult <= a1 * b1;
    v2 <= v1;
end

always_ff @(posedge clk) begin
    result <= mult;
    valid_out <= v2;
end



endmodule

