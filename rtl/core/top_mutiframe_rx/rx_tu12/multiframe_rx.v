// Filename     : multiframe_rx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module multiframe_rx
    (
     clk,
     rst,

     rxsof,
     datain,
     din_vld,
     
     endi0,            // 21 output parallel
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
   
     rei_vld0,   // REI valid
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

     rei_0,   // REI bip2
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
// Parameter declarations
parameter         WIDTH = 8;

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst;
input rxsof;
input endi0,            // 21 enable  parallel
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
      endi20;

//input             endi;
//output [WIDTH:0]  dataout; // multi 21 channel into 1 output
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

input [WIDTH-1:0]  datain;
input              din_vld;

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
////////////////////////////////////////////////////////////////////////////////
// Output declarations
//reg [WIDTH-1:0]    data_reg;
reg [4:0]          addwr;
reg [WIDTH-1:0]    data_reg;
// Local logic and instantiation
always @(posedge clk)
    begin
    if(rst)
        begin
        data_reg <= 0;
        addwr <=  0;
        end
    else if(rxsof)
        begin
        data_reg <= 0;
        addwr <=  0;
        end
    else if(din_vld)        
        begin
        data_reg <= datain;     // reveive data from tug3
        addwr <= (addwr == 20 )? 0 : addwr+1;  //   mapping into 21 multi TU12    
        end
    end
/*
always @(posedge clk)
    begin
    if(rst)
        begin  
        addrd <= 0; 
        end
    else if(endi)
        begin
        addrd <= (addrd == 20 ) ? 0: addrd+1;
        end
    
    end
*/
wire din_vld1;
fflopx #(1) fflop (.clk(clk),.rst_(!rst),.idat(din_vld),.odat(din_vld1));

egrtu12 #(0) egr0 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi0),
                   .addrd(5'd0),
                   .dout(out0),
                   .rei_bip2(rei_0),
                   .rei_vld(rei_vld0),
                   .rxsof(rxsof)
                   );

egrtu12 #(1) egr1 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi1),
                   .addrd(5'd1),
                   .dout(out1),
                   .rei_bip2(rei_1),
                   .rei_vld(rei_vld1),
                   .rxsof(rxsof)
                   );

egrtu12 #(2) egr2 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi2),
                   .addrd(5'd2),
                   .dout(out2),
                   .rei_bip2(rei_2),
                   .rei_vld(rei_vld2),
                   .rxsof(rxsof)
                   );

egrtu12 #(3) egr3 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi3),
                   .addrd(5'd3),
                   .dout(out3),
                   .rei_bip2(rei_3),
                   .rei_vld(rei_vld3),
                   .rxsof(rxsof)
                   );

egrtu12 #(4) egr4 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi4),
                   .addrd(5'd4),
                   .dout(out4),
                   .rei_bip2(rei_4),
                   .rei_vld(rei_vld4),
                   .rxsof(rxsof)
                   );

egrtu12 #(5) egr5 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi5),
                   .addrd(5'd5),
                   .dout(out5),
                   .rei_bip2(rei_5),
                   .rei_vld(rei_vld5),
                   .rxsof(rxsof)
                   );

egrtu12 #(6) egr6 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi6),
                   .addrd(5'd6),
                   .dout(out6),
                   .rei_bip2(rei_6),
                   .rei_vld(rei_vld6),
                   .rxsof(rxsof)
                   );

egrtu12 #(7) egr7 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi7),
                   .addrd(5'd7),
                   .dout(out7),
                   .rei_bip2(rei_7),
                   .rei_vld(rei_vld7),
                   .rxsof(rxsof)
                   );

egrtu12 #(8) egr8 (
                   .clk(clk),   
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi8),
                   .addrd(5'd8),
                   .dout(out8),
                   .rei_bip2(rei_8),
                   .rei_vld(rei_vld8),
                   .rxsof(rxsof)
                   );

egrtu12 #(9) egr9 (
                   .clk(clk),
                   .rst(rst),
                   .din_vld(din_vld1),
                   .addwr(addwr),
                   .datain(data_reg),
                   .endi(endi9),
                   .addrd(5'd9),
                   .dout(out9),
                   .rei_bip2(rei_9),
                   .rei_vld(rei_vld9),
                   .rxsof(rxsof)
                   );

egrtu12 #(10) egr10 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi10),
                     .addrd(5'd10),
                     .dout(out10),
                     .rei_bip2(rei_10),
                     .rei_vld(rei_vld10),
                     .rxsof(rxsof)
                     );

egrtu12 #(11) egr11 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi11),
                     .addrd(11),
                     .dout(out11),
                     .rei_bip2(rei_11),
                     .rei_vld(rei_vld11),
                     .rxsof(rxsof)
                     );

egrtu12 #(12) egr12 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi12),
                     .addrd(5'd12),
                     .dout(out12),
                     .rei_bip2(rei_12),
                     .rei_vld(rei_vld12),
                     .rxsof(rxsof)
                     );

egrtu12 #(13) egr13 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi13),
                     .addrd(5'd13),
                     .dout(out13),
                     .rei_bip2(rei_13),
                     .rei_vld(rei_vld13),
                     .rxsof(rxsof)
                     );

egrtu12 #(14) egr14 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi14),
                     .addrd(5'd14),
                     .dout(out14),
                     .rei_bip2(rei_14),
                     .rei_vld(rei_vld14),
                     .rxsof(rxsof)
                     );

egrtu12 #(15) egr15 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi15),
                     .addrd(5'd15),
                     .dout(out15),
                     .rei_bip2(rei_15),
                     .rei_vld(rei_vld15),
                     .rxsof(rxsof)
                     );

egrtu12 #(16) egr16 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi16),
                     .addrd(5'd16),
                     .dout(out16),
                     .rei_bip2(rei_16),
                     .rei_vld(rei_vld16),
                     .rxsof(rxsof)
                     );

egrtu12 #(17) egr17 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi17),
                     .addrd(5'd17),
                     .dout(out17),
                     .rei_bip2(rei_17),
                     .rei_vld(rei_vld17),
                     .rxsof(rxsof)
                     );

egrtu12 #(18) egr18 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi18),
                     .addrd(5'd18),
                     .dout(out18),
                     .rei_bip2(rei_18),
                     .rei_vld(rei_vld18),
                     .rxsof(rxsof)
                     );

egrtu12 #(19) egr19 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi19),
                     .addrd(5'd19),
                     .dout(out19),
                     .rei_bip2(rei_19),
                     .rei_vld(rei_vld19),
                     .rxsof(rxsof)
                     );

egrtu12 #(20) egr20 (
                     .clk(clk),
                     .rst(rst),
                     .din_vld(din_vld1),
                     .addwr(addwr),
                     .datain(data_reg),
                     .endi(endi20),
                     .addrd(5'd20),
                     .dout(out20),
                     .rei_bip2(rei_20),
                     .rei_vld(rei_vld20),
                     .rxsof(rxsof)
                     );
endmodule 
