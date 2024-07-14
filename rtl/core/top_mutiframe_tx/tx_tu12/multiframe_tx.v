// Filename     : multiframe_tx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module multiframe_tx
    (
     clk,
     rst,

     rei_vld0,
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
        
     di_vld, // data in valid
     datain,
     oid,

     do_vld,
     en,
     dataout

     );
parameter          WIDTH = 8;
////////////////////////////////////////////////////////////////////////////////
// Port declarations
input              clk,
                   rst;
input              rei_vld0,
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

input              en;
output             do_vld; // length = 15 , do_vld is set
output [WIDTH-1:0] dataout;
////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg [4:0]          count;      
reg [WIDTH-1:0]    d_reg;

////////////////////////////////////////////////////////////////////////////////

/*
always @(posedge clk)       
    begin
    if(rst)
        begin 
        d_reg <= 0;
        count <= 0;
        end        // count address to read 21 e1
    else if(di_vld)   // 
        begin
        d_reg <= datain;
        count <= count == 20 ? 0: count + 1;
        end
    else      
    end
*/
////////////////////////////////////////////////////////////////////////////////
wire [WIDTH-1:0]   out0,out1,out2,out3,out4,out5,out6,out7,out8,out9,
                   out10,out11,out12,out13,out14,out15,out16,
                   out17,out18,out19,out20;
wire               re;
wire               re0,re1,re2,re3,re4,re5,re6,re7,re8,re9,   // ALL LENGTH =15
                   re10,re11,re12,re13,re14,re15,re16,
                   re17,re18,re19,re20;

assign             re = re0&re2&re3&re4&re5&re6&re7&re8&re9&re10&re11&re12&
                   re13&re14&re15&re16&re17&re18&re19&re20;

wire               do_vld;

fflopx #(1) fflop (.clk(clk),.rst_(!rst),.idat(re),.odat(do_vld));

wire [WIDTH-1:0]   dataout;               
assign             dataout = out0|out1|out2|out3|out4|out5|out6|out7|out8|out9|
                   out10|out11|out12|out13|out14|out15|out16|out17|out18|out19|
                   out20;

reg [20:0]         enable;  // ENABLE DATA OUT
reg [20:0]         mask;


wire               en0,en1,en2,en3,en4,en5,en6,en7,en8,en9,en10,en11,
                   en12,en13,en14,en15,en16,en17,en18,en19,en20;

assign             {en0,en1,en2,en3,en4,en5,en6,en7,en8,en9,en10,
                    en11,en12,en13,en14,en15,en16,en17,en18,en19,en20} = enable;

    
always @(posedge clk) // en output
    begin
    if(rst)
        begin
        enable <= 21'b0;
        mask <= {1'b1,20'b0};
        end
        begin

    else if(en)
        begin
        enable <= mask;
        mask <= mask >>1;
        if(mask == 1) mask <= {1'b1,20'b0};
        end
    else
        begin
        enable <= 21'b0;
        end
    end
                  
gentu12 #(0) gen0 (
                   .clk(clk),
                   .rst(rst),
                                     
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   
                   .rei_vld(rei_vld0),
                   .rei_bip2(rei_0),
                   
                   .en(en0),
                   .dout(out0),
                   .re(re0)
                   );
                  
gentu12 #(1) gen1 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld1),
                   .rei_bip2(rei_1),
                   .en(en1),
                   .dout(out1),
                   .re(re1)
                   );
                  
gentu12 #(2) gen2 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld2),
                   .rei_bip2(rei_2),
                   .en(en2),
                   .dout(out2),
                   .re(re2)
                   );
                  
gentu12 #(3) gen3 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld3),
                   .rei_bip2(rei_3),
                   .en(en3),
                   .dout(out3),
                   .re(re3)
                   );
                  
gentu12 #(4) gen4 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld4),
                   .rei_bip2(rei_4),
                   .en(en4),
                   .dout(out4),
                   .re(re4)
                   );
                  
gentu12 #(5) gen5 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld5),
                   .rei_bip2(rei_5),
                   .en(en5),
                   .dout(out5),
                   .re(re5)
                   );
                  
gentu12 #(6) gen6 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld6),
                   .rei_bip2(rei_6),
                   .en(en6),
                   .dout(out6),
                   .re(re6)
                   );
                  
gentu12 #(7) gen7 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld),
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld7),
                   .rei_bip2(rei_7),
                   .en(en7),
                   .dout(out7),
                   .re(re7)
                   );
                  
gentu12 #(8) gen8 (
                   .clk(clk),
                   .rst(rst),
                   .valid(di_vld), 
                   .addr(oid),
                   .din(datain),
                   .rei_vld(rei_vld8),
                   .rei_bip2(rei_8),
                   .en(en8),
                   .dout(out8),
                   .re(re8)
                   );
                  
gentu12 #(9) gen9  (
                    .clk(clk),
                    .rst(rst),
                    .valid(di_vld),
                    .addr(oid),
                    .din(datain),
                    .rei_vld(rei_vld9),
                    .rei_bip2(rei_9),
                    .en(en9),
                    .dout(out9),
                    .re(re9)
                    );
                   
gentu12 #(10) gen10 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld10),
                     .rei_bip2(rei_10),
                     .en(en10),
                     .dout(out10),
                     .re(re10)
                     );
                    
gentu12 #(11) gen11 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld11),
                     .rei_bip2(rei_11),
                     .en(en11),
                     .dout(out11),
                     .re(re11)
                     );
                    
gentu12 #(12) gen12 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld12),
                     .rei_bip2(rei_12),
                     .en(en12),
                     .dout(out12),
                     .re(re12)
                     );

gentu12 #(13) gen13 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld13),
                     .rei_bip2(rei_13),
                     .en(en13),
                     .dout(out13),
                     .re(re13)
                     );
                    
gentu12 #(14) gen14 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld14),
                     .rei_bip2(rei_14),
                     .en(en14),
                     .dout(out14),
                     .re(re14)
                     );
                    
gentu12 #(15) gen15 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld15),
                     .rei_bip2(rei_15),
                     .en(en15),
                     .dout(out15),
                     .re(re15)
                     );
                    
gentu12 #(16) gen16 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld16),
                     .rei_bip2(rei_16),
                     .en(en16),
                     .dout(out16),
                     .re(re16)
                     );
                    
gentu12 #(17) gen17 (
                     .clk(clk),
                     .rst(rst),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld17),
                     .rei_bip2(rei_17),
                     .en(en17),
                     .dout(out17),
                     .re(re17)
                     );
                    
gentu12 #(18) gen18 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld),
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld18),
                     .rei_bip2(rei_18),
                     .en(en18),
                     .dout(out18),
                     .re(re18)
                     );
                    
gentu12 #(19) gen19 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld), 
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld19),
                     .rei_bip2(rei_19),
                     .en(en19),
                     .dout(out19),
                     .re(re19)
                     );
                    
gentu12 #(20) gen20 (
                     .clk(clk),
                     .rst(rst),
                     .valid(di_vld), 
                     .addr(oid),
                     .din(datain),
                     .rei_vld(rei_vld20),
                     .rei_bip2(rei_20),
                     .en(en20),
                     .dout(out20),
                     .re(re20)
                     );

endmodule 
