// Filename     : stm1p2s_wrapped.v
// Description  : STM-1 parallel to serial interface
////////////////////////////////////////////////////////////////////////////////

module stm1p2s_wrapped
    (
     clk155,
     rst155,

     clk19,
     rst19,

     rrow,
     rcol,
     pdi,

     b1dat,
     b1vld,
     b2dat,
     b2vld,
     
     sdo
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk155;
input rst155;

input clk19;
input rst19;

input [3:0] rrow;
input [6:0] rcol;
input [7:0] pdi;

output [7:0] b1dat;
output       b1vld;
output [23:0] b2dat;
output        b2vld;

output        sdo;

////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

wire          ps_sdo;
wire          sce;
piso    pisoi
    (
     .clk155(clk155),
     .rst155(rst155),

     .clk19(clk19),
     .rst19(rst19),
     
     .ps_rdat(pdi),
     .ps_rrow(rrow),
     .ps_rcol(rcol),
     
     .ps_sdo(ps_sdo),
     .sce(sce)
     );

wire          sc_sdo;
wire          sof;
scrambler   scrambleri
    (
     .clk155(clk155),
     .rst(rst155),
    
     .sc_sdi(ps_sdo),
     .sce(sce),
     
     .sc_sdo(sc_sdo),
     .sof(sof)
     );

b1cal   b1cali
    (
     .clk155(clk155),
     .rst(rst155),
     
     .sof(sof),  
     .b1sdi(sc_sdo),
     .b1pdo(b1dat),
     .b1vld(b1vld)
     );

b2cal   b2cali
    (
     .clk155(clk155),
     .rst(rst155),

     .b2sdi(ps_sdo),
     .sof(sof),
     .b2pdo(b2dat),
     .b2vld(b2vld)
     );

assign        sdo = sc_sdo;

endmodule 
