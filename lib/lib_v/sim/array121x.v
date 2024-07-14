// Filename     : array121x.v
// Description  : a library of a register array model with
//                  2 read ports and 1 write port.
////////////////////////////////////////////////////////////////////////////////

module array121x (rst_,wclk,wa,we,di,rclk1,ra1,do1,rclk2,ra2,do2);

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";		//This parameter is for synthesis only (Do not remove)
parameter MAXDEPTH = 0;

input               rst_;
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

ramrwpx #(ADDRBIT,DEPTH,WIDTH) ram1 (wclk,wa,we,di,rclk1,ra1,do1);
ramrwpx #(ADDRBIT,DEPTH,WIDTH) ram2 (wclk,wa,we,di,rclk2,ra2,do2);

endmodule

