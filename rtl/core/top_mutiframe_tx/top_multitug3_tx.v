// Filename     : top_multitug3_tx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module top_multitug3_tx
    (
     clk,  // clk19
     rst,
     txsof, // from mem
     
     rei_vld0,   // from top_multitug3_rx
     rei_vld1,
     rei_vld2,
     rei_vld3,
     rei_vld4,
     rei_vld5,
     rei_vld6,
     rei_vld7,
     rei_vld8,
     rei_vld9,
     rei_vld10,
     rei_vld11,
     rei_vld12,
     rei_vld13,
     rei_vld14,
     rei_vld15,
     rei_vld16,
     rei_vld17,
     rei_vld18,
     rei_vld19,
     rei_vld20,

     rei_0,
     rei_1,
     rei_2,
     rei_3,
     rei_4,
     rei_5,
     rei_6,
     rei_7,
     rei_8,
     rei_9,
     rei_10,
     rei_11,
     rei_12,
     rei_13,
     rei_14,
     rei_15,
     rei_16,
     rei_17,
     rei_18,
     rei_19,
     rei_20,
        
     di_vld, // data in valid  from Framer
     datain,  // data from framer
     oid;  // oid from framer

     tug3bip8,  // to vc4_tx
     bip_vld    // to vc4_tx
     
     entug3,  // from mem
     dotug3  // to mem

     );
   
parameter WIDTH = 8;

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input              clk,
                   rst;
input              txsof;

input              rei_vld0,   //from multiframe tu12 rx
                   rei_vld1,
                   rei_vld2,
                   rei_vld3,    
                   rei_vld4,    
                   rei_vld5,
                   rei_vld6,
                   rei_vld7,
                   rei_vld8,
                   rei_vld9,
                   rei_vld10,
                   rei_vld11,
                   rei_vld12,
                   rei_vld13,
                   rei_vld14,
                   rei_vld15,
                   rei_vld16,
                   rei_vld17,
                   rei_vld18,
                   rei_vld19,
                   rei_vld20;

input              rei_0,
                   rei_1,
                   rei_2,
                   rei_3,
                   rei_4,
                   rei_5,
                   rei_6,
                   rei_7,
                   rei_8,
                   rei_9,
                   rei_10,
                   rei_11,
                   rei_12,
                   rei_13,
                   rei_14,
                   rei_15,
                   rei_16,
                   rei_17,
                   rei_18,
                   rei_19,
                   rei_20;
input              di_vld;
input [WIDTH-1:0]  datain;
input [4:0]        oid;
input              entug3;
output [WIDTH-1:0] dotug3;
output [WIDTH-1:0] tug3bip8;
output             bip_vld;


////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
wire      do_vld;
wire      entu12;
wire [WIDTH-1:0] dataout;
wire             enable;

multiframe_tx
   multitu12 (
              .clk(clk),
              .rst(rst),
              
              .rei_vld0(rei_vld0),
              .rei_vld1(rei_vld1),
              .rei_vld2(rei_vld2),
              .rei_vld3(rei_vld3),
              .rei_vld4(rei_vld4),
              .rei_vld5(rei_vld5),
              .rei_vld6(rei_vld6),
              .rei_vld7(rei_vld7),
              .rei_vld8(rei_vld8),
              .rei_vld9(rei_vld9),
              .rei_vld10(rei_vld10),
              .rei_vld11(rei_vld11),
              .rei_vld12(rei_vld12),
              .rei_vld13(rei_vld13),
              .rei_vld14(rei_vld14),
              .rei_vld15(rei_vld15),
              .rei_vld16(rei_vld16),
              .rei_vld17(rei_vld17),
              .rei_vld18(rei_vld18),
              .rei_vld19(rei_vld19),
              .rei_vld20(rei_vld20),

              .rei_0(rei_0),
              .rei_1(rei_1),
              .rei_2(rei_2),
              .rei_3(rei_3),
              .rei_4(rei_4),
              .rei_5(rei_5),
              .rei_6(rei_6),
              .rei_7(rei_7),
              .rei_8(rei_8),
              .rei_9(rei_9),
              .rei_10(rei_10),
              .rei_11(rei_11),              
              .rei_12(rei_12),
              .rei_13(rei_13),
              .rei_14(rei_14),
              .rei_15(rei_15),
              .rei_16(rei_16),
              .rei_17(rei_17),
              .rei_18(rei_18),
              .rei_19(rei_19),
              .rei_20(rei_20),
        
              .di_vld(di_vld), // data in valid
              .datain(datain),
              .oid(oid),

              .do_vld(do_vld), // to tug3
              .en(entu12),      // from tug3_tx
              .dataout(dataout) // to tug3_tx

              );
tug3_tx
   tug3_tx (
            .clk(clk),
            .rst(rst),
            .txsof(txsof),
            .tug3din(dataout), //from tu12
            .di_vld(do_vld),  //from tu12
            .endin(entu12),  // to tu12
     
            .en(entug3),   // from mem
            .tug3dout(dotug3),  // to mem
     
            .bip_vld(bip_vld),  // to vc4_tx
            .bip8tug3(tug3bip8)    // bip8 tug3
     
            );
endmodule 
