// Filename     : iarray111x.v
// Description  : SMALL RAM implemented by a array of registers.
////////////////////////////////////////////////////////////////////////////////


(* keep_hierarchy = "yes" *) module iarray111x
    (
     wrst,
     wclk,
     wa,
     we,
     di,

     rrst,
     rclk,
     ra,
     re,
     do,

     test,
     mask
     );

parameter ADDRBIT = 9;
parameter DEPTH   = 512;
parameter WIDTH   = 8;
parameter TYPE = "AUTO";        //This parameter is for synthesis only (Do not remove)
parameter MAXDEPTH = 0;
parameter MEM_RESET = "OFF";
parameter NUMCLK= 1;// 1 is one clock domain, 2 is two clock domain

input               wrst;
input               wclk;
input [ADDRBIT-1:0] wa;     // @+clk
input               we;     // @+clk
input [WIDTH-1:0]   di;     // @+clk

input               rrst;
input               rclk;
input [ADDRBIT-1:0] ra;     // @+clk
input               re;
output [WIDTH-1:0]  do;     // @+clk

input               test;
input               mask;

wire [ADDRBIT-1:0]  iwa;
wire                iwe;
wire [WIDTH-1:0]    idi;
//wire [ADDRBIT-1:0]  ira;

//wire [WIDTH-1:0]    do;     // @+clk
reg [ADDRBIT-1:0]   cnt;

generate
    if (MEM_RESET == "ON")
        begin: on_reset
always @(posedge wclk) cnt <= cnt + 1'b1;
assign iwa  = wrst ? cnt : wa;
assign iwe  = wrst ? 1'b1 : we;
assign idi  = wrst ? {WIDTH{1'b0}} : di;
        end
    else
        begin: off_reset
assign iwa  = wa;
assign iwe  = we;
assign idi  = di;
        end
endgenerate

//read write port ram, dual clock instantiation
`ifdef  RTL_SIMULATION
iramrwpx #(ADDRBIT,DEPTH,WIDTH) array (wclk,iwa,iwe,idi,rclk,ra,re,do,test,mask);
`else
altsyncram111x #(ADDRBIT,DEPTH,WIDTH,TYPE, MAXDEPTH) ram
    (
    .data(idi),
    .wren(iwe),
    .wraddress(iwa),
    .rdaddress(ra),
    .wrclock(wclk),
    .rdclock(rclk),
    .q(do));
`endif
endmodule
