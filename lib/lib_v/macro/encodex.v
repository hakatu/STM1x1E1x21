// Filename     : encodex.v
// Description  : Parameterized encoding from a bitmap into a number.
////////////////////////////////////////////////////////////////////////////////

module encodex
    (
     in,
     out,
     nonz
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter       INW  = 256;
parameter       OUTW = 8;
parameter       VALUE = 1'b1;

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input [INW-1:0]     in;
output [OUTW-1:0]   out;
output              nonz;

////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
wire                nonz;
assign              nonz    = |in;

integer             i;
reg [OUTW-1:0]      out;
always @ (in)
    begin
    out = {OUTW{1'b0}};
    for (i=0;i<INW;i=i+1)
        begin
        if (in[i] == VALUE) out = i[OUTW-1:0];
        end
    end

endmodule 
