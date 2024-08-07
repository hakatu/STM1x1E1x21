// Filename     : iarray112x.v
// Description  : SMALL RAM implemented by a array of registers.
////////////////////////////////////////////////////////////////////////////////


module iarray112x
    (
     wrst_,
     wclk,
     wa,
     we,
     di,

     rrst_,
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

input               wrst_;
input               wclk;
input [ADDRBIT-1:0] wa;     // @+clk
input               we;     // @+clk
input [WIDTH-1:0]   di;     // @+clk

input               rrst_;
input               rclk;
input [ADDRBIT-1:0] ra;     // @+clk
input               re;
output [WIDTH-1:0]  do;     // @+clk

input               test;
input               mask;

wire [ADDRBIT-1:0]  iwa;
wire                iwe;
wire [WIDTH-1:0]    idi;
wire [ADDRBIT-1:0]  ira;
wire                ire;

wire [WIDTH-1:0]    ido;
reg [WIDTH-1:0]     do;     // @+clk

//
assign iwa  = wa;
assign iwe  = we;
assign idi  = di;
assign ira  = ra;
assign ire  = re;

// pipeline ram data out directly to data out bus
always @ (posedge rclk or negedge rrst_)
    if (~rrst_)
        do      <= {WIDTH{1'b0}};
    else
        do      <= ido; 

//read write port ram, dual clock instantiation
iramrwpx #(ADDRBIT,DEPTH,WIDTH) array (wclk,iwa,iwe,idi,rclk,ira,ire,ido,test,mask);

endmodule
