// Filename        : stickyx.v
// Description     : sticky bits, write "1" to clear
//////////////////////////////////////////////////////////////////////////////////

module stickyx
    (
     clk,
     rst,
     upactive,
     alarm,
     upen,
     upws,
     updi,
     updo,
     lalarm
     );

parameter           WIDTH = 8;
input               clk;
input               rst;
input               upactive;
input               upen;           // processor enable
input               upws;           // processor write strobe
input   [WIDTH-1:0] alarm;          // alarms in
input   [WIDTH-1:0] updi;           // processor data in

output  [WIDTH-1:0] updo;           // processor data out
output  [WIDTH-1:0] lalarm;         // latched alarms out

wire                we;
assign we = upen & upws;

reg     [WIDTH-1:0] lalarm;

assign updo = upen ? lalarm : {WIDTH{1'b0}};

always @(posedge clk)
    begin
    if (rst) 
        lalarm <= {WIDTH{1'b0}};
    else if (~upactive)
        begin
        if(we) lalarm <= updi;
        end
    else if (we)
        lalarm <= alarm | (lalarm & ~updi);
    else 
        lalarm <= alarm | lalarm;
    end

endmodule
