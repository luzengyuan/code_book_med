
module st_mac_engine#(
parameter W = 8
)
(
input logic clk,
input logic resetn,

input  logic valid_in,
input  logic [7:0]  A,
input  logic [7:0]  B,

output logic valid_out
output logic [31:0] result

);

//internal registers
//mult_result
//accumulator
//pipeline_valid

//valid_in → v1 → v2 → valid_out
//v1 <= valid_in;
//v2 <= v1;
//valid_out <= v2;

logic [2*W-1:0] mult;
logic [2*W+15:0] acc;
logic v1, v2;

always_ff @(posedge clk) begin
    mult <= A * B;
    v1   <= valid_in;
end

always_ff @(posedge clk) begin
    acc <= acc + mult;
    v2  <= v1;
end

always_ff @(posedge clk) begin
    result <= acc;
    valid_out <= v2;
end

endmodule