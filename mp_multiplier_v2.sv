//add backpressure

module pipelined_mult_bp #(
    parameter int W = 16
) (
    input  logic             clk,
    input  logic             rst_n,

    input  logic             in_valid,
    output logic             in_ready,
    input  logic [W-1:0]     a,
    input  logic [W-1:0]     b,

    output logic             out_valid,
    input  logic             out_ready,
    output logic [2*W-1:0]   result
);

logic [W-1:0]     s1_a, s1_b;
logic [2*W-1:0]   s2_mult;
logic [2*W-1:0]   s3_result;
logic             v1, v2, v3;

logic r1, r2, r3;

assign r3 = out_ready || !v3;
assign r2 = r3 || !v2;
assign r1 = r2 || !v1;

assign in_ready  = r1;
assign out_valid = v3;
assign result    = s3_result;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        v1 <= 1'b0;
        v2 <= 1'b0;
        v3 <= 1'b0;
    end else begin
        // stage 3
        if (r3) begin
            v3 <= v2;
            if (v2)
                s3_result <= s2_mult;
        end

        // stage 2
        if (r2) begin
            v2 <= v1;
            if (v1)
                s2_mult <= s1_a * s1_b;
        end

        // stage 1
        if (r1) begin
            v1 <= in_valid;
            if (in_valid) begin
                s1_a <= a;
                s1_b <= b;
            end
        end
    end
end

endmodule