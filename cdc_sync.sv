//Design a module transferring a single pulse event from clkA → clkB.

module pulse_cdc
(
input logic clk_a,
input logic resetn_a,
input logic p_in,

input logic clk_b,
input logic resetn_b,
output logic p_o
);

//idea
//convert pulse to edge in clock a
logic edge_a;

always_ff@(posedge clk_a or negedge resetn_a)
if(!resetn_a) begin
	edge_a <= 0;
	end
else
	if(p_in)
		edge_a <= !edge_a;

//sample by two registers at clock b
logic sync_r1, sync_r2;

always_ff@(posedge clk_b or negedge resetn_b)
if(!resetn_b) begin
	sync_r1 <= 0;
	sync_r2 <= 0;
end
else begin
	sync_r1 <= edge_a;
	sync_r2<= sync_r1;
end
	
logic sync_r3;

always_ff @(posedge clk_b or negedge resetn_b) begin
    if (!resetn_b) begin
        sync_r3 <= 1'b0;
        p_o     <= 1'b0;
    end else begin
        sync_r3 <= sync_r2;
        p_o     <= sync_r2 ^ sync_r3;
    end
end

endmodule