// Filename     : stm1s2p_wrapped.v
// Description  : STM-1 serial to parallel interface
////////////////////////////////////////////////////////////////////////////////

module stm1s2p_wrapped
    (
     clk155,
     rst155,

     clk19,
     rst19,
     
     sdi,

     pdo,
     sof,
     b2dat,
     b2vld
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk155;
input rst155;

input clk19;
input rst19;

input sdi;

output [7:0] pdo;
output       sof;
output [23:0] b2dat;
output        b2vld;
              
////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

wire      fra_sdo;
wire      sce;
fr_align    fr_aligni
    (
     .clk155(clk155),
     .rst(rst155),

     .sdi(sdi),
     .sdo(fra_sdo),
     .sce(sce)
     );

wire      sc_sdo;
wire      sc_sof;
scrambler   scrambleri
    (
     .clk155(clk155),
     .rst(rst155),
    
     .sc_sdi(fra_sdo),
     .sce(sce),
     
     .sc_sdo(sc_sdo),
     .sof(sc_sof)
     );

sipo    sipoi
    (
     .clk155(clk155),
     .rst155(rst155),

     .clk19(clk19),
     .rst19(rst19),
     
     .sdi(sc_sdo),
     .sof155(sc_sof),
     .pdo(pdo),
     .sof19(sof)
     );

b2cal    b2cali
    (
     .clk155(clk155),
     .rst(rst155),

     .b2sdi(sc_sdo),
     .sof(sc_sof),
     .b2pdo(b2dat),
     .b2vld(b2vld)
     );

endmodule 
