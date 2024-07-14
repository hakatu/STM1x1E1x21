// Filename     : bridgerx.v
// Description  : address decode from STM-1 to E1 (left to right, downto) & data
//              mux
////////////////////////////////////////////////////////////////////////////////

module bridgerx
    (
     clk19,
     rst,
     
     row,//from counter
     col,
     sts,

     tug3en, //to TUG3
     
     vc4en, // to VC4
     
     au4en, // to AU4
     inc,// from AU4
     dec,
     
     stmen,// to STM

     dobus,//common data out bus for stm,au,vc
     
     datain // from stm serial interface module
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter           WID = 8;
parameter           RWID = 4;
parameter           CWID = 7;
parameter           SWID = 2;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

input [RWID-1:0]    row;
input [CWID-1:0]    col;
input [SWID-1:0]    sts;

output              tug3en;

output              vc4en;

output              au4en;
input               inc;
input               dec;

output              stmen;
output [WID-1:0]    dobus;

input [WID-1:0]     datain;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

fflopx #(WID) shfdat (clk19, rst, datain, dobus);

reg [2:0]           cnt;
always @(posedge  clk19)
    begin
    if (rst)
        cnt <= 3'b000;
    else if ((inc && !dec) || (cnt))
        cnt <= cnt + 1;
    end

assign  stmen   =   ((row <= 4'd2) || (row >= 4'd4)) && (col <= 7'd2);

assign  au4en   =   (row == 4'd3) && (col <= 7'd2);

assign  vc4en   =   ((col >= 7'd3) &&
                     (col <= 7'd5) &&
                     !((cnt >= 3'd3) &&
                       (cnt <= 3'd5)));

assign  tug3en  =   (col >= 7'd6) && (sts == 0);

endmodule 
