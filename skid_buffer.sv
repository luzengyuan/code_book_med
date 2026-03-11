module skid_buffer #(
    parameter int WIDTH = 32
) (
    input  logic             clk,
    input  logic             rst_n,

    input  logic             in_valid,
    input  logic [WIDTH-1:0] in_data,
    output logic             in_ready,

    output logic             out_valid,
    output logic [WIDTH-1:0] out_data,
    input  logic             out_ready
);

logic             buf_valid;
logic [WIDTH-1:0] buf_data;

assign out_valid = buf_valid | in_valid;
assign out_data  = buf_valid ? buf_data : in_data;
assign in_ready  = ~buf_valid | out_ready;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) buf_valid <= 1'b0;
    else begin
        if (in_valid && in_ready && !out_ready) begin
            buf_valid <= 1'b1;
            buf_data  <= in_data;
        end else if (out_ready) begin
            buf_valid <= 1'b0;
        end
    end
end

endmodule