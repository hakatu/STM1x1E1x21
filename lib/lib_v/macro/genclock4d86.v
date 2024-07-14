// Filename     : genclock4d86.v
// Description  : Generates clock 4.86MHz from 19.44MHz with Frame sync
////////////////////////////////////////////////////////////////////////////////

module genclock4d86
    (
     rst_,
     iclk19,
     frmsync,
     oclk4d86
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input           rst_;
input           iclk19;
input           frmsync;
output          oclk4d86;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg             frmsync_rt; // re-time multiframe sync
always @(negedge iclk19 or negedge rst_)
    begin
    if (!rst_)  frmsync_rt  <= 1'b0;
    else if(frmsync_rt) frmsync_rt <= 1'b0;
    else        frmsync_rt  <= frmsync;
    end

reg [1:0] cntph;
always @(posedge iclk19 or negedge rst_)
    begin
    if (!rst_)              cntph <= 2'd0;
    else if (frmsync_rt)    cntph <= 2'd0;
    else                    cntph <= cntph + 1'b1;
    end

wire            oclk4d86;
assign oclk4d86 = cntph[1];

endmodule 
