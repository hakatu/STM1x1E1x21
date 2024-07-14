// Filename     : rdygen.v
// Description  : Stretch cpu ready signals for cpu interface
////////////////////////////////////////////////////////////////////////////////

module rdygen_cc
    (
     clk,
     pce_,
     rdyin,
     rdyout_ccxxx
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk;
input   pce_;
input   rdyin;
output  rdyout_ccxxx;

wire        cerst;
assign      cerst = pce_;

reg     rdyout_ccxxx = 1'b0 /* synthesis preserve */;   // set multicycle from this signal
always @ (posedge clk)
    begin
    if (cerst)    rdyout_ccxxx <= 1'b0;
    else
        case (rdyin)
            1'b1:       rdyout_ccxxx <= rdyin;
            default:    rdyout_ccxxx <= rdyout_ccxxx;
        endcase
    end

endmodule