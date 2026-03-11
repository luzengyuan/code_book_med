//Design a module that tracks up to 8 outstanding transactions.
//detect duplicate issue
//detect completion without issue

module axi_os_tracker(
input logic clk,
input logic resetn,

input logic issue_valid,
input logic[2:0] issue_id,
input logic complete_valid,
input logic [2:0] complete_id,

output logic slot_available,
output logic error_duplicate
);

//idea
//example
//1, 2, 3, 4, 6,5
//2, 3, 4,
logic [7:0] tag_store;

//write side
//if issue and complete same time;

//only issue

//only compl

//every valid issue will put tag_store value to 1
// if already as 1, then error_duplicate

//every compl will write tag_store value to 0

//counter
// issue and compl: no change
// issue: +1
// compl: -1


always_ff@(posedge clk or negedge resetn)
if(!resetn) begin
	tag_store <= '0;
	error_duplicate <= 0;
	end
else begin
	if(issue_valid && complete_valid) begin
		if(issue_id == complete_id) begin
		;
		end
		else begin
			if (tag_store[issue_id] == 1 || tag_store[compl_id] == 0) 
				error_duplicate <= 1;
			
			tag_store[issue_id] <= 1;
			tag_store[complete_id] <= 0;
		end
	else if(issue_valid) begin
		if (tag_store[issue_id] == 1)				
			error_duplicate <= 1;
		tag_store[issue_id] <= 1;
		end
	else if (complete_valid) begin
		if (tag_store[complete_id] == 0)
			error_duplicate <= 1;
		tag_store[complete_id] <= 0;
		end
	end
 
logic [3:0] cnt;
always_ff@(posedge clk or negedge resetn)
if(!resetn)
	cnt <= '0;
else
	case({issue_valid,complete_valid})
		2'b01: cnt <= cnt -1;
		2'b10: cnt <= cnt +1;
		default: ;
	endcase

assign slot_available = (cnt !=8);


endmodule