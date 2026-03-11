//Parameterized FIFO with Almost Full/Empty
module fifo#(
parameter DAT_WIDTH = 32,
parameter DEPTH = 8
)
(
input logic clk,
input logic resetn,
input logic [DAT_WIDTH-1:0] data_in,
input logic push,
output logic full,
output logic almost_full,

output logic [DAT_WIDTH-1:0] data_out,
output logic empty,
output logic almost_empty,
input logic pop

);

//power-of-2 depth
logic [$clog2(DEPTH+1):0] rdp,wrp;

logic [DAT_WIDTH-1:0] buffer [DEPTH-1:0];

//write side
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
wrp <= '0;
end
else if (!full and push)
begin
	buffer[wrp] <= data_in;
	wrp <= wrp + 1;
end

//read side
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
rdp <= '0;
end
else if (!empty and pop)
begin
	data_out <=buffer[rdp] ;
	rdp <= rdp + 1;
end

assign empty = (wrp == rdp)? 1:0;
assign full = (wrp == rdp + DEPTH)?1:0;



endmodule
