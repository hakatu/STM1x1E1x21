// File Name: alt_ddr_output.v

module alt_ddr_output (
    datain_h,
    datain_l,
    outclock,
    dataout);

parameter   PAD_WIDTH = 8;

    input   [PAD_WIDTH-1:0]  datain_h;
    input   [PAD_WIDTH-1:0]  datain_l;
    input     outclock;
    output  [PAD_WIDTH-1:0]  dataout;

wire [PAD_WIDTH-1:0]         dataout;
assign                       dataout = outclock ? datain_h : datain_l;

endmodule
