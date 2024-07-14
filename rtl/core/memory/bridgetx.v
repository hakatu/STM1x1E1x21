// Filename     : bridgetx.v
// Description  : address decode from E1 to STM-1 (left to right, downto) & data
//              mux
////////////////////////////////////////////////////////////////////////////////

module bridgetx
    (
     clk19,
     rst,
     
     row,
     col,
     sts,

     tug3en,
     tug3di,
     
     vc4en,
     vc4di,
     
     au4en,
     au4di,
     
     stmen,
     stmdi,
     
     dataout
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter           WID = 8;
parameter           RWID = 4;
parameter           CWID = 7;
parameter           SWID = 2;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input               clk19;
input               rst;

input [RWID-1:0]    row;
input [CWID-1:0]    col;
input [SWID-1:0]    sts;

output              tug3en;
input [WID-1:0]     tug3di;

output              vc4en;
input [WID-1:0]     vc4di;

output              au4en;
input [WID-1:0]     au4di;

output              stmen;
input [WID-1:0]     stmdi;

output [WID-1:0]    dataout;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

wire [WID-1:0]       dataout;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

assign              stmen = ((row <= 4'd2) || (row >= 4'd4)) && (col <= 7'd2); 

assign              au4en = (row == 4'd3) && (col <= 7'd2);

assign              vc4en = (col >= 7'd3) && (col <= 7'd5);

assign              tug3en = (col >= 7'd6) && (sts == 0);

assign  dataout = stmen? stmdi :
        au4en?  au4di   :
        vc4en?  vc4di   :
        tug3en? tug3di  : 8'b0;

endmodule 
