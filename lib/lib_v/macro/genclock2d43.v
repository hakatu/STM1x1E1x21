// Filename     : genclock2d43.v
// Description  : Generates clock 2.43MHz from 19.44MHz with Frame sync
//                Developing based on genclock4d86.v
////////////////////////////////////////////////////////////////////////////////

module genclock2d43
    (
     rst_,
     iclk19,
     frmsync,
     oclk2d43,
     oclk4d86
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations
parameter CNT2_RST = 0;
//parameter CNT4_RST = 3;
parameter CNT4_RST = 0; //changed by ndthanh, Mon Mar 19 10:59:48 2007

input           rst_;
input           iclk19;
input           frmsync;
output          oclk2d43;
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

reg [2:0] cnt2;
always @(posedge iclk19 or negedge rst_)
    begin
    if (!rst_)              cnt2 <= 3'd0;
    else if (frmsync_rt)    cnt2 <= CNT2_RST;
    else                    cnt2 <= cnt2 + 1'b1;
    end

wire            oclk2d43;
assign          oclk2d43 = cnt2[2];


reg [1:0] cnt4;
always @(posedge iclk19 or negedge rst_)
    begin
    if (!rst_)              cnt4 <= 2'd0;
    else if (frmsync_rt)    cnt4 <= CNT4_RST;
    else                    cnt4 <= cnt4 + 1'b1;
    end

wire            oclk4d86;
assign          oclk4d86 = cnt4[1];

endmodule 
