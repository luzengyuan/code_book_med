//sync fifo
module sync_fifo#(
parameter W = 32,
parameter D = 8
)(
input logic clk,
input logic resetn,

input logic valid_in,
input logic [W-1:0] data_in,
output logic ready_in,

output logic valid_out,
output logic[W-1:0] data_out,
input logic ready_out

);

//intstaniate buffer
logic [W-1:0] buffer [D-1:0];
logic [$clog2(D+1)-1:0] cnt;

//wrp, rdp
logic [$clog2(D)-1:0] wrp,rdp;
logic empty, full;

assign empty = (cnt == 0);
assign full = (cnt == D);

assign ready_in = !full;
assign valid_out = !empty;

assign write_fire = valid_in && ready_in;
assign read_fire  = valid_out && ready_out;

//write interface
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	wrp <= '0;
end
else begin
	if(write_fire) begin
	//update buffer
		buffer[wrp] <= data_in;
	//address control
		if (wrp == D-1) begin
			wrp <= 0;
		end
		else begin
			wrp <= wrp + 1;
		end
	end
end

//read interface
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	rdp <= '0;
	data_out <= '0;
end
else begin
	if (read_fire) begin
	data_out <= buffer[rdp];
	
	if(rdp == D -1) begin
		rdp <= 0;
		end
	else begin
		rdp <= rdp + 1;
		end
	end
end


//control interface
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	cnt <= '0;
end
else begin
	case({(write_fire),(read_fire)})
	2'b01: begin
		cnt <= cnt -1;
	end
	2'b10: begin
		cnt <= cnt + 1;
	end
	default : ;
	endcase
end

endmodule