// Filename     : array111x.v
// Description  : a library of a register array model with
//                  1 read ports and 1 write port.
////////////////////////////////////////////////////////////////////////////////

(* keep_hierarchy = "yes" *) module array111x (rst,wclk,wa,we,di,rclk,ra,do);

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;
parameter MEM_RESET = "OFF";
parameter NUMCLK= 1;// 1 is one clock domain, 2 is two clock domain

input               rst;
input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;
input               rclk;
input [ADDRBIT-1:0] ra;
output [WIDTH-1:0]  do;
reg [ADDRBIT-1:0]   cnt;
wire [ADDRBIT-1:0]  iwa;
wire                iwe;
wire [WIDTH-1:0]    idi;

generate
    if (MEM_RESET == "ON")
        begin: on_reset
always @(posedge wclk) cnt <= cnt + 1'b1;
assign iwa  = rst ? cnt : wa;
assign iwe  = rst ? 1'b1 : we;
assign idi  = rst ? {WIDTH{1'b0}} : di;
        end
    else
        begin: off_reset
assign iwa  = wa;
assign iwe  = we;
assign idi  = di;
        end
endgenerate

`ifdef  RTL_SIMULATION
wire   sameadd = (iwe & (iwa == ra));
wire   re = !sameadd;
iramrwpx #(ADDRBIT,DEPTH,WIDTH) array (wclk,iwa,iwe,idi,rclk,ra,re,do,1'b0,1'b0);
`else
altsyncram111x #(ADDRBIT,DEPTH,WIDTH,TYPE,MAXDEPTH) ram(idi,iwe,iwa,ra,wclk,rclk,do);
`endif
endmodule