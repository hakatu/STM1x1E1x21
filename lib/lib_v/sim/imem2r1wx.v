// Filename     : imem2r1wx.v
// Description  : 
////////////////////////////////////////////////////////////////////////////////

module imem2r1wx
    (
     wrst_,
     wclk,
     wa,
     we,
     di,

     r1rst_,
     rclk1,
     ra1,
     re1,
     do1,

     r2rst_,
     rclk2,
     ra2,
     re2,
     do2,

     test,
     mask
     );

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";        //This parameter is for synthesis only (Do not remove)
parameter MAXDEPTH = 0;

input               wrst_;
input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;

input               r1rst_;
input               rclk1;
input [ADDRBIT-1:0] ra1;
input               re1;
output [WIDTH-1:0]  do1;

input               r2rst_;
input               rclk2;
input [ADDRBIT-1:0] ra2;
input               re2;
output [WIDTH-1:0]  do2;

input               test;
input               mask;

imemrwpx #(ADDRBIT,DEPTH,WIDTH) ram1
    (wrst_,wclk,wa,we,di,r1rst_,rclk1,ra1,re1,do1,test,mask);
imemrwpx #(ADDRBIT,DEPTH,WIDTH) ram2
    (wrst_,wclk,wa,we,di,r2rst_,rclk2,ra2,re2,do2,test,mask);

endmodule

