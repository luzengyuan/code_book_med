module pp_arbiter #(
    parameter int N  = 4,
    parameter int PW = 3
) (
    input  logic [N-1:0] req,
    input  logic [PW-1:0] prio [N],
    output logic [N-1:0] grant
);

always_comb begin
    grant = '0;

    int best_idx = -1;
    logic [PW-1:0] best_prio = '0;

    for (int i = 0; i < N; i++) begin
        if (req[i]) begin
            if ((best_idx == -1) || (prio[i] > best_prio)) begin
                best_idx  = i;
                best_prio = prio[i];
            end
        end
    end

    if (best_idx != -1)
        grant[best_idx] = 1'b1;
end

endmodule