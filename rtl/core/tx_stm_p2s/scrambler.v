// Filename     : scrambler.v
// Description  : This module scrambles incoming data.
////////////////////////////////////////////////////////////////////////////////

module scrambler
    (
     clk155,
     rst,
    
     sc_sdi,
     sce,
     
     sc_sdo,
     sof
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk155;
input   rst;

input   sce; // scrambling enable
output  sof; // indicate the start of frame for b1cal.v

input   sc_sdi;
output  sc_sdo;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [6:0] x;
reg       sce_prv;   // scrambling enable signal in the previous state

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

always @(posedge clk155)
    begin
    if (rst)
        begin
        x <= 7'b111_1111;
        sce_prv <= 1'b1;
        end
    else if (sce)
        begin
        sce_prv <= sce;
        x <= {x[5:0], x[6] ^ x[5]};
        end
    else
        begin
        x <= 7'b111_1111;
        sce_prv <= sce;
        end
    end

assign sc_sdo = sce ? sc_sdi ^ x[6] : sc_sdi;
assign sof = sce_prv & ~sce;

endmodule 

