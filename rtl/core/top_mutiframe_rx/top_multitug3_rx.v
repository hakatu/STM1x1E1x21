// Filename     : top_multitug3_rx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module top_multitug3_rx
        (
         clk,  //clk19
         rst,

         rxsof, // from mem
         en,   // from mem
         tug3din,  // from mem

         tug3bip8,      // to vc4_rx
         bip_vld,       // to vc4_rx
     
         endi0,            // 21 endi input parallel
         endi1,
         endi2,
         endi3,
         endi4,
         endi5,
         endi6,
         endi7,
         endi8,
         endi9,
         endi10,
         endi11,
         endi12,
         endi13,
         endi14,
         endi15,
         endi16,
         endi17,
         endi18,
         endi19,
         endi20,
     
         out0,  // 21 parallel output
         out1,
         out2,
         out3,
         out4,
         out5,
         out6,
         out7,
         out8,
         out9,
         out10,
         out11,
         out12,
         out13,
         out14,
         out15,
         out16,
         out17,
         out18,
         out19,
         out20,
   
         rei_vld0,   // REI valid output
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
         
         rei_0,   // REI bip2 output
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
         rei_20
         );
parameter WIDTH =8;
////////////////////////////////////////////////////////////////////////////////
input clk,
      rst;
input rxsof;
output [WIDTH-1:0] out0,    // 21 output parallel
                   out1,
                   out2,
                   out3,
                   out4,
                   out5,
                   out6,
                   out7,
                   out8,
                   out9,
                   out10,
                   out11,
                   out12,
                   out13,
                   out14,
                   out15,
                   out16,
                   out17,
                   out18,
                   out19,
                   out20;

input [WIDTH-1:0]  tug3din;
input              en;

output             rei_vld0,
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

output             rei_0,
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
output [WIDTH-1:0] tug3bip8;
output             bip_vld;
////////////////////////////////////////////////////////////////////////////////
wire tug3_ovld;        // from tug3_rx to multitu12
wire [WIDTH-1:0] tug3dout;

multiframe_rx
   multi_rx (
             .clk(clk),
             .rst(rst),

             .rxsof(rxsof),
             .datain(tug3dout),
             .din_vld(tug3_ovld),
     
             .endi0(endi0),            // 21 output parallel
             .endi1(endi1),
             .endi2(endi2),
             .endi3(endi3),
             .endi4(endi4),
             .endi5(endi5),
             .endi6(endi6),
             .endi7(endi7),
             .endi8(endi8),
             .endi9(endi9),
             .endi10(endi10),
             .endi11(endi11),
             .endi12(endi12),
             .endi13(endi13),
             .endi14(endi14),
             .endi15(endi15),
             .endi16(endi16),
             .endi17(endi17),
             .endi18(endi18),
             .endi19(endi19),
             .endi20(endi20),
     
             .out0(out0),  // 21 parallel output
             .out1(out1),
             .out2(out2),
             .out3(out3),
             .out4(out4),
             .out5(out5),
             .out6(out6),
             .out7(out7),
             .out8(out8),
             .out9(out9),
             .out10(out10),
             .out11(out11),
             .out12(out12),
             .out13(out13),
             .out14(out14),
             .out15(out15),
             .out16(out16),
             .out17(out17),
             .out18(out18),
             .out19(out19),
             .out20(out20),
                 
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
             .rei_20(rei_20)

     );
tug3_rx
   tug3_rx (
            .clk(clk),
            .rst(rst),
     
            .en(en),     
            .rxsof(rxsof),
            .tug3din(tug3din),
     
            .tug3bip8(tug3bip8),
            .bip_vld(bip_vld),
     
            .tug3dout(tug3dout),
            .data_vld(tug3_ovld)
     );   

     

endmodule 
