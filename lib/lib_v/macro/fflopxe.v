// Filename        : fflopxe.v
// Description     : variable size enable flip flop
//////////////////////////////////////////////////////////////////////////////////
(* keep_hierarchy = "yes" *) module fflopxe
    (
     clk,
     rst,
     latch_en,
     idat,
     odat
     );

parameter WIDTH = 8;
parameter RESET_VALUE = {WIDTH{1'b0}};

input   clk, rst, latch_en;
input   [WIDTH-1:0] idat;

output  [WIDTH-1:0] odat;
reg     [WIDTH-1:0] odat = {WIDTH{1'b0}};

always @ (posedge clk)
    begin
    //if(!rst_) odat <= RESET_VALUE;
    if (latch_en) odat <= idat;
    end

endmodule
