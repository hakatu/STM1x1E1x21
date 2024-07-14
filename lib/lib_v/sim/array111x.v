// Filename     : array111x.v
// Description  : a library of a register array model with
//                  1 read ports and 1 write port.
////////////////////////////////////////////////////////////////////////////////

module array111x (rst_,wclk,wa,we,di,rclk,ra,do);

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;
parameter MEM_RESET = "OFF";

input               rst_;
input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;
input               rclk;
input [ADDRBIT-1:0] ra;
output [WIDTH-1:0]  do;

ramrwpx #(ADDRBIT,DEPTH,WIDTH) ram (wclk,wa,we,di,rclk,ra,do);

endmodule