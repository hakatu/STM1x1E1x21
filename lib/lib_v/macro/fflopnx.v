// Filename        : fflopnx.v
// Description     : variable size flip flop
//////////////////////////////////////////////////////////////////////////////////
(* keep_hierarchy = "yes" *) module fflopnx
    (
     clk,
     rst,
     idat,
     odat
     );

parameter WIDTH = 8;
parameter RESET_VALUE = {WIDTH{1'b0}};

input   clk, rst;

input  [WIDTH-1:0] idat;

output [WIDTH-1:0] odat;
reg    [WIDTH-1:0] odat = RESET_VALUE;

//always @ (posedge clk or negedge rst_)
always @ (posedge clk)
    begin
    //if(!rst_) odat <= RESET_VALUE;
    //else odat <= idat;
    odat <= idat;
    end

endmodule
