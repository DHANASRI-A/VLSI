`timescale 1ns/1ps
module clk_counter(q, clk, rst);
output [7:0] q;
input clk,rst;
wire c_out;
clockdivider clk_div(c_out,clk,rst);
counter cnt(q,c_out, rst);

endmodule
module clockdivider( c_out,clk,rst);
output reg c_out;
input clk,rst;
reg [27:0]count;
always @(posedge clk or negedge rst)
begin
if(!rst)begin
c_out<=0;
count<=0;
end
else if( count==50000000 )begin
count<=0;
c_out<=~c_out;
end
else begin
count<=count+1;

end 
end

endmodule
module counter(q,c_out,rst);
output reg [7:0]q;
input c_out,rst;
always @(posedge c_out or negedge rst )begin
if(!rst)begin
q<=8'b00000000;
end
else begin
q<=q+1;
end
end 
endmodule
