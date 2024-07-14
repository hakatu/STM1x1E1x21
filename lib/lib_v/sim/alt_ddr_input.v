module alt_ddr_input (
    datain,
    inclock,
    dataout_h,
    dataout_l);

     parameter PAD_WIDTH = 8;
    input   [PAD_WIDTH-1:0]  datain;
    input     inclock;
    output  [PAD_WIDTH-1:0]  dataout_h;
    output  [PAD_WIDTH-1:0]  dataout_l;

reg [PAD_WIDTH-1:0]          dataout_h;
reg [PAD_WIDTH-1:0]          dataout_l;
reg [PAD_WIDTH-1:0]          dataout_lo;

always @(posedge inclock)
    dataout_h <= datain;

always @(negedge inclock)
    dataout_lo <= datain;

always @(posedge inclock)
    dataout_l <= dataout_lo;

endmodule
