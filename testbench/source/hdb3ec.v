// Filename     : hdb3ec.v
// Description  : HDB3 encoder
////////////////////////////////////////////////////////////////////////////////

module hdb3ec
    (
     clk2,//2mhz clock
     rst,

     //from framer
     serin,

     //to LIU
     pos,
     neg
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk2;
input rst;

input serin;

output pos;
output neg;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

wire   amipos, amineg;

//Serial to AMI converter
amiec amieci
    (
     .clk(clk2),
     .rst(rst),

     .serin(serin), //serial data in

     .opos(amipos),//signal out
     .oneg(amineg)
     );

//AMI to HDB3

amihdb3ec amihdb3eci
    (
     .clk(clk2),
     .rst(rst),

     .ipos(amipos), //ami data in
     .ineg(amineg),
     
     .opos(pos),//signal out
     .oneg(neg)
     );


endmodule 
