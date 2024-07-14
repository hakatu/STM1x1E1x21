// Filename     : e1frwrapped.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module e1frwrapped
    (
     clk2,
     clk19,
     rst,

     //to and from hdb3 line coder
     serin,
     serout,

     //to VC VT
     dataout,
     dovld,
     ais,

     //from VC VT
     datain,
     divld,
     endi,

     //from LIU
     los
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

output [WID-1:0] dataout;
output           dovld;
output           ais;

input [WID-1:0]  datain;
input            divld;
output           endi;

input            los;

////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

e1rxfr e1rxfri
    (
     .clk2(clk2),  //e1 clock
     .clk19(clk19), //sys clock
     .rst(rst),   //atcive high reset

     //from HDB3
     .serin(serin),         //serial input

     //to VC VT
     .dataout(dataout),            //8 bit data out
     .dovld(dovld),         //data out valid
     .aisdet(ais),        //alarms indicator detect for V5

     //From LIU
     .losdet(los)         //loss of signal detect
     );

e1txfr e1txfri
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     //to VC VT
     .datain(datain),
     .divld(divld),
     .endi(endi), //data in enable

     //to HDB3 Encoder
     .serout(serout)
     );

endmodule 
