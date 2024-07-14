// Filename     : hdb3.v
// Description  : HDB3 Encoder/Decoder with NRZ bypass but no HDB3 error detect
//                  working at 2mhz clock for e1 2048 application
////////////////////////////////////////////////////////////////////////////////

module hdb3wrapped
    (
     clk2,
     rst,

     //from LIU
     rpos, //positive and negative line
     rneg,

     //to LIU
     tpos,
     tneg,

     //framer
     serin, //serial
     serout,

     //NRZ
     nrzmode
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   rst;

input   rpos;
input   rneg;

output  tpos;
output  tneg;

input   serin;
output  serout;

input   nrzmode;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

wire   serouthdb3;

hdb3ec hdb3eci
    (
     .clk2(clk2),//2mhz clock
     .rst(rst),

     //from framer
     .serin(serin),

     //to LIU
     .pos(tpos),
     .neg(tneg)
     );

hdb3dc hdb3dci
    (
     .clk(clk2),
     .rst(rst),

     .epos(rpos),  //input from HDB3 LIU
     .eneg(rneg),

     .enrz(serouthdb3) // to framer
     );

assign serout = (nrzmode)? rpos : serouthdb3;

endmodule 
