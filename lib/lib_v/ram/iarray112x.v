// Filename     : iarray112x.v
// Description  : SMALL RAM implemented by a array of registers.
////////////////////////////////////////////////////////////////////////////////


(* keep_hierarchy = "yes" *) module iarray112x
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
parameter NCLK = 2;// 2: use ram2clk, 1: use ram 1clk + pp output  

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

reg [ADDRBIT-1:0]  cnt;

generate
    if (MEM_RESET == "ON")
        begin: on_reset
    (* KEEP = "TRUE" *) reg array_reset_ccxxx = 1'b0;
    
always @ (posedge wclk)
    begin
    if (wrst)   array_reset_ccxxx <= 1'b1;
    else        array_reset_ccxxx <= 1'b0;
    end

always @(posedge wclk) cnt <= cnt + 1'b1;
assign iwa  = array_reset_ccxxx ? cnt : wa;
assign iwe  = array_reset_ccxxx ? 1'b1 : we;
assign idi  = array_reset_ccxxx ? {WIDTH{1'b0}} : di;
        end
    else
        begin: off_reset
assign iwa  = wa;
assign iwe  = we;
assign idi  = di;
        end
endgenerate

`ifdef  RTL_SIMULATION
wire [WIDTH-1:0]   ido;     // @+clk
reg [WIDTH-1:0]    do;

always @ (posedge rclk) do <= ido;
iramrwpx #(ADDRBIT,DEPTH,WIDTH) array (wclk,iwa,iwe,idi,rclk,ra,re,ido,test,mask);

`else
alsyncram112x #(ADDRBIT,DEPTH,WIDTH,TYPE, MAXDEPTH, NUMCLK, NCLK) mem
    (
    .data(idi),
    .wren(iwe),
    .wraddress(iwa),
    .rdaddress(ra),
    .wrclock(wclk),
    .rdclock(rclk),
    .q(do)
    );
`endif

endmodule
