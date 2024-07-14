// Filename     : memctrlwrapped.v
// Description  : Main memory control with Tx/Rx counter and data mux
////////////////////////////////////////////////////////////////////////////////

module memctrlwrapped
    (
     clk19,
     rst,

     row, //to tx p2s
     col,
     sts,
     dotx,

     dirx,//from rx s2p
     rxsof,

     tug3entx,//to tx tug3
     tug3di,

     tug3enrx, //to rx TUG3
     tug3do,
     
     vc4entx,//to tx vc4
     vc4di,

     vc4enrx, // to rx VC4
     vc4do,
     
     au4entx,//to tx au4
     au4di,

     au4enrx, // to rx AU4
     au4do,
     
     inc,// from AU4
     dec,
     
     stmentx,//to tx stm
     stmdi,
     
     stmenrx,// to rx STM
     stmdo,

     txsof
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter WID = 8,
          RWID = 4,
          CWID = 7,
          SWID = 2,
          MAXROW = 9,
          MAXCOL = 90,
          MAXSTS = 3,         
          RESETVALUE = 0;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

output [RWID-1:0] row;
output [CWID-1:0] col;
output [SWID-1:0] sts;
output [WID-1:0]  dotx;

input [WID-1:0]   dirx;
input             rxsof;

output            tug3entx;
input [WID-1:0]   tug3di;

output            tug3enrx;
output [WID-1:0]  tug3do;

output            vc4entx;
input [WID-1:0]   vc4di;

output            vc4enrx;
output [WID-1:0]  vc4do;

output            au4entx;
input [WID-1:0]   au4di;

output            au4enrx;
output [WID-1:0]  au4do;

input             inc;
input             dec; 

output            stmentx;
input [WID-1:0]   stmdi;

output            stmenrx;
output [WID-1:0]  stmdo;

output            txsof;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

//Transmit counter

wire [RWID-1:0] rowtx;
wire [CWID-1:0] coltx;
wire [SWID-1:0] ststx;

rwrccnt #(RWID,CWID,SWID,MAXROW,MAXCOL,MAXSTS,RESETVALUE) cnttxi
    (
     .clk19(clk19),
     .rst(rst),

     .rxsof(1'b0),

     .row(rowtx),
     .col(coltx),
     .sts(ststx),

     .inc(1'b0),
     .dec(1'b0)
     );

//Transmit bridge

bridgetx #(WID,RWID,CWID,SWID) bridgetxi
    (
     .clk19(clk19),
     .rst(rst),
     
     .row(rowtx),
     .col(coltx),
     .sts(ststx),

     .tug3en(tug3entx),
     .tug3di(tug3di),
     
     .vc4en(vc4entx),
     .vc4di(vc4di),
     
     .au4en(au4entx),
     .au4di(au4di),
     
     .stmen(stmentx),
     .stmdi(stmdi),
     
     .dataout(dotx)
     );

assign          txsof = ((row == MAXROW) & (col == MAXCOL)) & (sts == MAXSTS);

//Receive counter

wire            cnt_rst;
wire [RWID-1:0] rowrx;
wire [CWID-1:0] colrx;
wire [SWID-1:0] stsrx;
wire [WID-1:0]  dobus;

rwrccnt #(RWID,CWID,SWID,MAXROW,MAXCOL,MAXSTS,RESETVALUE) cntrxi
    (
     .clk19(clk19),
     .rst(rst),
    
     .rxsof(rxsof),
     
     .row(rowrx),
     .col(colrx),
     .sts(stsrx),

     .inc(inc),
     .dec(dec)
     );

//Receive Bridge

bridgerx #(WID,RWID,CWID,SWID) bridgerxi
    (
     .clk19(clk19),
     .rst(rst),
     
     .row(rowrx),//from counter
     .col(colrx),
     .sts(stsrx),

     .tug3en(tug3enrx), //to TUG3
     
     .vc4en(vc4enrx), // to VC4
     
     .au4en(au4enrx), // to AU4
     .inc(inc),// from AU4 
     .dec(dec),
     
     .stmen(stmenrx),// to STM

     .dobus(dobus),//common data out bus for stm,au,vc
     
     .datain(dirx) // from stm serial interface module
     );

assign    vc4do = dobus;
assign    au4do = dobus;
assign    stmdo = dobus;
assign    tug3do = dobus;

endmodule 
