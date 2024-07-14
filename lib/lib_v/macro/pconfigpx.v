// Filename        : pconfigx.v
// Description     : Variable width processor config register
//////////////////////////////////////////////////////////////////////////////////
module pconfigpx
    (
     clk,
     rst,
     upen,
     upws,
     updi,
     out,
     par_dis,
     par_err,
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

input               par_dis; // Disable parity calculation for testing
output              par_err;

//----------------------------------------------
wire    [WIDTH-1:0] out;
reg     [WIDTH-1:0] xxxfpcfg = RESET_VALUE;
assign              out = xxxfpcfg;

assign updo = upen ? xxxfpcfg : {WIDTH{1'b0}};

always @(posedge clk)
    begin
    if(rst) xxxfpcfg <= RESET_VALUE;
    else if(upen & upws) xxxfpcfg <= updi;
    end

reg                 xxxpar;
always @ (posedge clk)
    begin
    if (rst) xxxpar <= ^RESET_VALUE;
    else if(upen & upws & (!par_dis)) xxxpar <= ^updi;
    end
wire par_err;
assign par_err = xxxpar ^ (^xxxfpcfg);

endmodule
