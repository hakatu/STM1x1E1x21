// Filename     : e1frwrapped.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module e1frwrapped
    (
     clk2,
     clk19,
     rst,

     serin, // from HDB3
     serout,//to hdb3

     rclk, //from rx LIU

     //to VC VT
     dataout,
     dovld,

     //from VC VT
     datain,
     endi19,

     //from LIU
     los,

     //crc monitor
     rxcrcerr,
     rxcrcmfa
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter WID = 8;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   clk19;
input   rst;

input   serin;
output  serout;

input   rclk;

output [WID-1:0] dataout;
output           dovld;

input [WID-1:0]  datain;
output           endi19;

input            los;
output           rxcrcerr;
output           rxcrcmfa;

////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

e1rxfr e1rxfri
    (
     .clk2(rclk),  //e1 clock
     .clk19(clk19), //sys clock
     .rst(rst),   //atcive high reset

     //from HDB3
     .serin(serin),         //serial input

     //to VC VT
     .dataout(dataout),            //8 bit data out
     .dovld(dovld),         //data out valid

     //From LIU
     .losdet(los),         //loss of signal detect
     .crcerr(rxcrcerr),
     .crcmfa(rxcrcmfa)
     );

e1txfr e1txfri
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     //to VC VT
     .datain(datain),
     .endi19(endi19), //data in enable

     //to HDB3 Encoder
     .serout(serout)
     );

endmodule 
