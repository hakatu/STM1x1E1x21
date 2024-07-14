// Filename     : amiec.v
// Description  : ami encoder with pos, neg and zero when pos and neg is zero
////////////////////////////////////////////////////////////////////////////////

module amiec
    (
     clk,
     rst,

     serin, //serial data in

     opos,//signal out
     oneg
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input   clk;
input   rst;

input   serin;

output  opos;
output  oneg;

////////////////////////////////////////////////////////////////////////////////
// Signal declarations

////////////////////////////////////////////////////////////////////////////////
// serial in to AMI
// serial in shift register
wire    [1:0]   sinrg;

fflopx #(2) ffsini (clk,rst,{sinrg[0],serin},sinrg);

//polar logic

wire    amipolar;

fflopx #(1) ffamipolari (clk, rst, amipolar ^ sinrg[0], amipolar);//one cycle early


//reg             amiposrg,aminegrg; //pos and neg register
wire    [1:0]   amio,amionxt;

fflopx #(2) ffami (clk,rst,amionxt,amio);

assign          amionxt = {(sinrg[1] & !amipolar),(sinrg[1] & amipolar)};
assign          {opos,oneg} =   amio;

////////////////////////////////////////////////////////////////////////////////

endmodule