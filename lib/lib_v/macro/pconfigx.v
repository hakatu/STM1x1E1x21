// Filename        : pconfigx.v
// Description     : Variable width processor config register
//////////////////////////////////////////////////////////////////////////////////
module pconfigx
    (
     clk,
     rst,
     upen,
     upws,
     updi,
     out,
     updo
     );

parameter WIDTH = 8;
parameter RESET_VALUE = {WIDTH{1'b0}};

input   clk,
        rst,
        upen,               // Microprocessor enable
        upws;               // Microprocessor write strobe
        
input   [WIDTH-1:0] updi;   // Microprocessor data in

output  [WIDTH-1:0] out;

output  [WIDTH-1:0] updo;   // Microprocessor data out

reg     [WIDTH-1:0] xxxfpcfg = RESET_VALUE;

assign updo = upen ? xxxfpcfg : {WIDTH{1'b0}};

always @(posedge clk)
    begin
    if(rst) xxxfpcfg <= RESET_VALUE;
    else if(upen & upws) xxxfpcfg <= updi;
    end
assign out = xxxfpcfg;

endmodule
