// Filename     : array121x.v
// Description  : a library of a register array model with
//                  2 read ports and 1 write port.
////////////////////////////////////////////////////////////////////////////////

(* keep_hierarchy = "yes" *) module array121x (rst,wclk,wa,we,di,rclk1,ra1,do1,rclk2,ra2,do2);

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;
parameter NUMCLK= 1;// 1 is one clock domain, 2 is two clock domain

input               rst;
input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;
input               rclk1;
input [ADDRBIT-1:0] ra1;
output [WIDTH-1:0]  do1;
input               rclk2;
input [ADDRBIT-1:0] ra2;
output [WIDTH-1:0]  do2;

array111x #(ADDRBIT,DEPTH,WIDTH,TYPE,MAXDEPTH) ram1 (rst,wclk,wa,we,di,rclk1,ra1,do1);
array111x #(ADDRBIT,DEPTH,WIDTH,TYPE,MAXDEPTH) ram2 (rst,wclk,wa,we,di,rclk2,ra2,do2);

endmodule

