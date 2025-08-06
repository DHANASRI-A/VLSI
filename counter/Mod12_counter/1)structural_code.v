`timescale 1ns / 1ps
module mod12(clk_in,y,clr);
input clk_in,clr;
output wire [4:1]y;
wire not_y4,clk;
assign not_y4=~y[4];
wire j4,j3,j2,j1,k4,k3,k2,k1;
and j4_1(j4,y[2],y[1],y[3]);
and j3_1(j3,y[2],y[1],not_y4);
and k4_1(k4,y[2],y[1]);
and k3_1(k3,y[2],y[1]);
assign j2=y[1];
assign k2=y[1];
assign j1=1'b1;
assign k1=1'b1;
jk_ff ff_1(j4,k4,clk,y[4],clr);
jk_ff ff_2(j3,k3,clk,y[3],clr);
jk_ff ff_3(j2,k2,clk,y[2],clr);
jk_ff ff_4(j1,k1,clk,y[1],clr);
clockdivider clk_div(clk_in,clk,clr);
endmodule
module jk_ff(j,k,clk,q,clr);
input j,k,clk,clr;
output reg q;
always@(posedge clk or negedge clr)
  begin
    if(!clr)
     q<=1'b0;
    else if(clr)
     case ({j,k})
       2'b00:q<=q;
       2'b01:q<=1'b0;
       2'b10:q<=1'b1;
       2'b11:q<=~q;
     endcase 
  end
endmodule
module clockdivider( clk_in,clk,clr);
output reg clk;
input clk_in ,clr;
reg [27:0]count;
always @(posedge clk_in or negedge clr)
  begin
      if(!clr)begin
      clk<=0;
      count<=0;
    end
      else if( count==50000000 )begin
      count<=0;
      clk<=~clk;
    end
      else begin
      count<=count+1;
    end 
  end
endmodule
