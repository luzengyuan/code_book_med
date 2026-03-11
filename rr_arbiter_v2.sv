module rr_arbiter #(
    parameter int N = 4
) (
    input  logic         clk,
    input  logic         resetn,
    input  logic [N-1:0] req,
    output logic [N-1:0] grant
);

logic [$clog2(N)-1:0] last_grant;

always_comb begin
    grant = '0;
    bit found;
    int idx;
    found = 0;

    for (int i = 0; i < N; i++) begin
        idx = (last_grant + 1 + i) % N;
        if (req[idx] && !found) begin
            grant[idx] = 1'b1;
            found = 1'b1;
        end
    end
end

always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        last_grant <= '0;
    end else begin
        for (int i = 0; i < N; i++) begin
            if (grant[i])
                last_grant <= i;
        end
    end
end

endmodule