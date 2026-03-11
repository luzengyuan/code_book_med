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

logic [DAT_WIDTH-1:0] buffer[DEPTH-1:0] ;
logic [$clog2(DEPTH)-1:0] rdp,wrp;

//write side
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	wrp <= 0;
end
else if (!full && push) begin
	buffer[wrp] <= data_in;
	if(wrp == DEPTH-1)
		wrp <= 0;
	else
		wrp <= wrp +1;
end

//read side
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	rdp <= 0;
end
else if(!empty && pop) begin
data_out <= buffer[rdp];
	if(rdp == DEPTH-1)
		rdp <= 0;
	else
		rdp <= rdp + 1;
end

//counter
logic[$clog2(DEPTH+1)-1:0] cnt;
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	cnt <= '0;
end
else begin
	case({(!full && push),(!empty && pop)})
	2'b10:
		cnt <= cnt +1;
	2'b01:
		cnt <= cnt -1;
	default:
		cnt <= cnt;
	endcase
end

assign full = (cnt == DEPTH)? 1:0;
assign empty = (cnt == 0)? 1:0;

assign almost_full  = (cnt >= DEPTH-1);
assign almost_empty = (cnt <= 1);

endmodule