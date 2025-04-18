`timescale 1ns/1ps
module single_module(q,clk,rst);
output reg [2:0]q;
input clk,rst;
reg clk_out;
reg [27:0]count;
always @(posedge clk or negedge rst)begin
if(!rst)begin
count<=0;
clk_out<=0;
end
else if(count==50000000)begin
count<=0;
clk_out<=~clk_out;
end
else begin
count<=count+1;
end
end
always @(posedge clk_out or negedge rst)begin
if(!rst)begin
q<=3'b000;
end
else begin
q<=1+q;
end 
end
endmodule
