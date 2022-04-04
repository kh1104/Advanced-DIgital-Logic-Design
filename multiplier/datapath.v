`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:21:36 02/11/2022 
// Design Name: 
// Module Name:    datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module datapath(input lda,ldb,ldp,dreb,clrp,
                output eqz
    );
	 wire [15:0] x,y,z,bus;
	 
	 load1 A(x,bus,lda,clk);
	 load2 P(y,ldp,clrp,z,clk);
	 load3 B(bout,ldb,bus,dreb,clk);
	 Adder add(z,x,y);
	 Compare comp(bout,eqz);
	


endmodule

module load1(x,bus,lda,clk);
      input [15:0] bus;
      input lda,clk;
      output reg [15:0] x;
	always@(posedge clk)
	    if(lda)
		 x<=bus;
		


endmodule

module load2(y,ldp,clrp,z,clk);
     input [15:0] z;
	  input ldp,clrp,clk;
	  output reg [15:0] y;
	 always@(posedge clk)
	    if(clrp)
		    y<=16'b00;
       else if(ldp)
          y <= z;		 
endmodule

module load3(bout,ldb,bus,dreb,clk);
     input [15:0] bus;
	  input dreb,ldb,clk;
	  output reg[15:0] bout;
	always@(posedge clk)
	    if(ldb)
		   bout <= bus;
		else if(dreb)
		  bout<=bout-1;
	      
endmodule

module Adder(z,x,y);
input [15:0] x,y;
output reg [15:0] z;
 always@(*)
  z = x + y;
endmodule

module Compare(bout,eqz);
input[15:0] bout;
output eqz;
 
 assign eqz = (bout==0);

endmodule
