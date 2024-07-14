// Filename        : iarraysp2x.v
// Description     : a library of Wrapped single-port ram
////////////////////////////////////////////////////////////////////////////////// 

module iarraysp2x
    (
     clk,
     rst_,
     a,
     we,
     re,
     di,
     do,

     test,
     mask
     );

parameter ADDRBIT = 11;
parameter DEPTH = 1536;
parameter WIDTH = 32;
parameter TYPE = "AUTO";        //This parameter is for synthesis only (Do not remove)
parameter MAXDEPTH = 0;

input               clk;
input               rst_;
input [ADDRBIT-1:0] a;
input               we;
input               re;
input [WIDTH-1:0]   di;
output [WIDTH-1:0]  do;
input               test;
input               mask;

wire [ADDRBIT-1:0]  ia;
wire                iwe;
wire                ire;
wire [WIDTH-1:0]    idi;
wire [WIDTH-1:0]    ido;
reg [WIDTH-1:0]     do;

//wrapping logics
//input
assign ia   = a;
assign iwe  = we;
assign idi  = di;
assign ire  = re;

//output
always @ (posedge clk or negedge rst_)
    if (~rst_)  do  <= {WIDTH{1'b0}};
    else        do  <= ido;

//single-port ram instantiation
iramspx #(ADDRBIT,DEPTH,WIDTH) ram (clk,ia,iwe,ire,idi,ido,test,mask);

endmodule
