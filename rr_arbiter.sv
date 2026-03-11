module rr_arbiter#(parameter N = 4)
(
input logic clk,
input logic resetn,
input logic[N-1:0] req,
output logic[N-1:0] grant
);

logic [$clog2(N)-1:0] last_grant;

//start from last_grant+1
always_comb begin
grant = '0;
for(int i =0; i < N; i++)
	grant[(last_grant+1+i)%N] = req[(last_grant+1+i)%N] && (|grant == 0);
end


always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	last_grant <= 0;
end
else begin
	for(int i = 0; i <N;i++)
		if(grant[i])
			last_grant <= i;

end

endmodule