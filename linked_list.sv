module free_list_allocator #(
    parameter int N = 16
) (
    input  logic                     clk,
    input  logic                     resetn,

    input  logic                     alloc_req,
    output logic                     alloc_gnt,
    output logic [$clog2(N)-1:0]     alloc_idx,

    input  logic                     free_req,
    input  logic [$clog2(N)-1:0]     free_idx,

    output logic                     empty,
    output logic [$clog2(N+1)-1:0]   free_count,
    output logic                     error_double_free
);

    localparam int IDX_W = $clog2(N);
    localparam int PTR_W = $clog2(N+1);
    localparam logic [PTR_W-1:0] NULL_PTR = N[PTR_W-1:0];

    logic [PTR_W-1:0] next_ptr [N-1:0];
    logic [N-1:0]     in_free;
    logic [PTR_W-1:0] free_head;

    logic alloc_fire, free_fire;

    assign empty     = (free_count == 0);
    assign alloc_gnt = alloc_req && !empty;
    assign alloc_idx = free_head[IDX_W-1:0];

    assign alloc_fire = alloc_req && !empty;
    assign free_fire  = free_req;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            free_head <= '0;
            free_count <= N[PTR_W-1:0];
            error_double_free <= 1'b0;

            for (int i = 0; i < N; i++) begin
                in_free[i] <= 1'b1;
                if (i == N-1)
                    next_ptr[i] <= NULL_PTR;
                else
                    next_ptr[i] <= (i+1);
            end
        end else begin
            error_double_free <= 1'b0;

            // allocation pops old head
            if (alloc_fire) begin
                in_free[free_head[IDX_W-1:0]] <= 1'b0;
                free_head <= next_ptr[free_head[IDX_W-1:0]];
            end

            // free pushes node to head
            if (free_fire) begin
                if (in_free[free_idx]) begin
                    error_double_free <= 1'b1;
                end else begin
                    next_ptr[free_idx] <= free_head;
                    free_head <= free_idx;
                    in_free[free_idx] <= 1'b1;
                end
            end

            // free_count update
            case ({alloc_fire, free_fire && !in_free[free_idx]})
                2'b10: free_count <= free_count - 1'b1;
                2'b01: free_count <= free_count + 1'b1;
                default: ;
            endcase
        end
    end

endmodule