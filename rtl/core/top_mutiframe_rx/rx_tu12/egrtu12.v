// Filename     : egrtu12.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module egrtu12
    (
     clk,
     rst,
     rxsof,
     
     din_vld,
     addwr,
     datain, 

     endi,
     addrd,
     dout,
     
     rei_bip2,
     rei_vld     
     );
parameter          ADDR = 5'b0;
parameter          WIDTH = 8;
////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst;
input rxsof;

input din_vld;
input [WIDTH-1:0] datain;   
input [4:0]       addwr;

input             endi;
input [4:0]       addrd;
output [WIDTH-1:0] dout;

output             rei_bip2;
output             rei_vld;

////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg [9:0]          row;  // count 0 - 143 row
reg [1:0]          bip2;
reg [1:0]          bip2_pre;

reg                rei_vld;
reg [1:0]          v5_bip2;

reg                enptr;   // enable pointer 
reg [WIDTH-1:0]    dinptr;

wire [9:0] offset ;
ptr_int
    ptr_int(
            .clk(clk),
            .rst(rst),

            .din(dinptr),  // data pointer in
            .en(enptr),  // enable pointer in
            .rxsof(rxsof),  // start of frame 
            .poffset(offset), // offset of v5
           
            .lop(),
            .ais()
            );

wire               ptr_pos; // pointer position
assign             ptr_pos = (row == 0)| (row == 36) |(row == 72) | (row == 108);
      
////////////////////////////////////////////////////////////////////////////////
always @(posedge clk)
    begin
    if(rst)
        begin
        rei_vld <= 1'b0;
        bip2 <= 2'b0;
        bip2_pre <= 8'b0;
        v5_bip2 <= 1'b0;
        row <= 10'd0; 
        enptr <= 1'b0;       
        end
    else if(rxsof)
        begin
        rei_vld <= 1'b0;
        bip2 <= 2'b0;
        bip2_pre <= 8'b0;
        v5_bip2 <= 1'b0;
        row <= 10'd0; 
        enptr <= 1'b0;            
        end
    else if((addwr == ADDR) & din_vld)
        begin
        if(ptr_pos)
            begin
            if(row == 0)
                begin
                bip2 <= 2'b0;  // reset bip2
                bip2_pre <=bip2; // store previous bip2 
                end
            dinptr <= datain;
            enptr <= 1'b1;
            row <= row +10'd1;      
           end
        else 
            begin
            if ( row == addrv5)
                begin
                v5_bip2 <= datain[1:0];
                rei_vld <= 1'b1;   // REI valid when receive V5     
                end
            bip2[0] <= bip2[0]^(^(datain&(8'b10101010)));
            bip2[1] <= bip2[1]^(^(datain&(8'b01010101)));     
            row     <= ( row == 143 ) ? 10'd0 : row+10'd1;            
            enptr   <= 1'b0;
           end
        end
    else rei_vld <= 0;
    end            

////////////////////////////////////////////////////////////////////////////////
//calculate rei
assign rei_bip2 = bip2_pre[0]^v5_bip2[0]|bip2_pre[1]^v5_bip2[1];
////////////////////////////////////////////////////////////////////////////////

wire [5:0]        addrpoh;  // addr of byte poh
wire [5:0]        addrstf1, // addr of byte stuff
                  addrstf2; // addr of byte stuff

wire [9:0] addrv5; // position of v5
assign     addrv5 = 
           ((offset >= 0) & (offset <= 34 )) ?(offset+10'd37):
           ((offset >=35) & (offset <= 69 )) ?(offset+'10'd38):
           ((offset >=70) & (offset <= 104)) ?(offset +10'd39):
           (offset -10'd104);

assign  addrpoh =  
        ((offset >=0 ) & (offset <= 34)) ?offset:
        ((offset >=35) & (offset <= 69)) ?(offset-10'd35):
        ((offset >=70) & (offset <= 104))?(offset -10'd70):
(10'd105-offset);

assign     addrstf1 = (addrpoh == 34)?6'd0:(addrpoh +6'd1);
assign     addrstf2 = (addrpoh == 0 )?6'd34:(addrpoh -6'd1);
////////////////////////////////////////////////////////////////////////////////
reg [WIDTH-1 : 0] multitu12 [0:34];

wire   we;
assign we = (!ptr_pos)&din_vld; // enable write data to multi tu12 (except pointer)

reg [5:0] i;
reg [5:0] cntfr;   // count position, write data to multitu12
reg [5:0] cntdo;   // count position, read data

always @(posedge clk)
    begin
    if(rst)
        begin
        for(i=0;i <= 34; i=i+1)
            multitu12[i] <= {WIDTH{1'b0}};
        cntdo <= 6'd0;
        end
    if(rxsof)
        begin
        for(i=0;i <= 34; i=i+1) multitu12[i] <= {WIDTH{1'b0}};
        cntdo <= 6'd0;
        end
    else if(we) multitu12[cntfr] <= datain;
    else if(endi&(addrd==ADDR))
        begin
        dout <= multitu12[cntdo];       
        cntdo <= cntdo +6'd1;       
        end
    else
        begin
        cntdo <= (cntdo == 6'd34)? 6'd0:
                 (cntdo == addrpoh)?(cntdo +5'd1):
                 (cntdo == addrstf1)?(cntdo+5'd1):
                 (cntdo == addrstf2)?(cntdo+5'd1):cntdo;      
        end
    end
endmodule 
