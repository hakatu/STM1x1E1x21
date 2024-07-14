module IPAD (PAD, O);
parameter WIDE = 1;

output [WIDE-1:0] O;
input  [WIDE-1:0] PAD;

wire [WIDE-1:0] O = PAD;
endmodule