//Design a module managing credits for a downstream queue.

module credit_fc#(
parameter CREDIT = 8
)
(
input logic clk,
input logic resetn,
input logic send_valid,
input logic credit_return,

output logic send_ready

);

//idea
//this design will update credit pool with credit_return
logic [$clog2(CREDIT+1)-1:0] credit;

logic hs;

assign hs = send_valid && send_ready;

always_ff@(posedge clk or negedge resetn)
if(!resetn)
	credit <= CREDIT;
else
	case({hs,credit_return})
	2'b10:
		//underflow handling
		credit <= credit - 1;
	2'b01:
		//overfolow handling
		if(credit < CREDIT) 
			credit <= credit + 1;
	default: 
		;
	endcase
	
//if credit >0, send_ready is high
assign send_ready = (credit > 0)? 1: 0;


endmodule