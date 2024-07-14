// Filename        : iramrwpx.v
// Description     : a library of read write port RAM model with dual clocks
//////////////////////////////////////////////////////////////////////////////////

module iramrwpx
    (
     wclk,
     wa,
     we,
     di,
     
     rclk,
     ra,
     re,
     do,
     
     test,
     mask
     );

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;
parameter DISPLAY_ERR_RAM_WR = "ON";
parameter DISPLAY_ERR_RAM_RD = "ON";
parameter ERR_RAM_WR_X  = "ON";
parameter ERR_RAM_RD_X  = "ON";

input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;
input               rclk;
input [ADDRBIT-1:0] ra;
input               re;
output [WIDTH-1:0]  do;
input               mask;   // =1 -> re is disable
input               test;   // wr and rd are disable

reg [WIDTH-1:0] ram [DEPTH-1:0]/*synthesis syn_ramstyle = "block_ram" */;
//reg [WIDTH-1:0] ram [DEPTH-1:0]/*synthesis syn_ramstyle = "RAMB8BWER" */;
reg [WIDTH-1:0] do;

integer i;
initial begin for(i=0;i<DEPTH;i=i+1) ram[i] = {WIDTH{1'b0}}; end

always @ (posedge wclk)
    begin
    if (we)
            begin
            ram[wa] <= di;
            end
         
    end

always @ (posedge rclk)
    begin
    if (re)
            begin
            do  <= ram[ra];
            end
    else    do  <= {WIDTH{1'bx}};
    end


endmodule

