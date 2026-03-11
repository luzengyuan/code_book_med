//design sliding window counter
module sw_counter(
input logic clk,
input logic resetn,

input logic event,
//value range from 0 to 1024
output logic [10:0] cnt
);

//idea
//every time the top value is poped out and one new value is pushed in
//initialize buffer/fifo to store 1024 event value
//initialize temp to track the current value in buffer/fifo
//every time read one value and push one value

logic [1023:0] buffer;
logic [9:0] rdp, wrp;

//rdp from 0
//wrp from 1023
//both wrap from 1023 to 0
//write port will update value based on event
always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	wrp <= 10'd1023;
	buffer <= '0;
	end
else begin
	buffer[wrp] <= event;
	wrp <= wrp + 1;
end 

always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	rdp <= '0;
	end
else begin
	rdp <= rdp + 1;
end

always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	cnt <= '0;
end
else begin
	cnt <= cnt + event - buffer[rdp];
end

endmodule
