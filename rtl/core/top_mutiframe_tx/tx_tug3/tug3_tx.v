// Filename     : tug3_tx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module tug3_tx
    (
     clk,
     rst,
     txsof,
     tug3din,
     di_vld,
     endin,
     
     en,
     tug3dout,
     
     bip_vld,
     bip8tug3    // bip8 tug3
     
     );

////////////////////////////////////////////////////////////////////////////////
parameter   ROW    = 9,
            COLT3  = 86,
            WIDTH  = 8;
parameter   NPI1 = 8'b1001_1011;
parameter   NPI2 = 8'b1110_0000;
parameter   NPI3 = 8'b0;
                
// Port declarations
input clk,
      rst;
input txsof;

input di_vld;
input [WIDTH-1:0]   tug3din;
output              endin;

input               en;
output[WIDTH-1:0]   tug3dout;
output [WIDTH-1:0]  bip8tug3;
output              bip_vld;      
////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg [5:0]           a,
                    b,
                    i,
                    j,
                    r,
                    c;
reg [WIDTH-1:0]     bip8tug3;
reg [WIDTH-1:0]     bip8tug3_reg;           
reg [WIDTH-1:0]     tug3dout;


reg [WIDTH-1:0]     tug3dout_reg [ROW-1:0][COLT3-1:0];
reg                 empty;
reg                 bip_vld;
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
//assign we = empty|((a<=r)&((b+1)<=c))
wire [WIDTH-1:0]    bip8stuff;
assign              bip8stuff = NPI1^NPI2^NPI3;
always @(posedge clk)
    begin
    if(rst)
        begin
        a <= 0;
        b <= 2;     // data of tug3 start at col 2
        empty <= 1;         // start reading
        tug3dout_reg[0][0]  <=   NPI1;  //STUFF & NULL POINTER INDICATOR
        tug3dout_reg[0][1]  <=   8'b0;
        tug3dout_reg[1][0]  <=   NPI2;
        tug3dout_reg[1][1]  <=   8'b0;
        tug3dout_reg[2][0]  <=   NPI3;
        tug3dout_reg[2][1]  <=   8'b0;
        tug3dout_reg[3][0]  <=   8'b0;
        tug3dout_reg[3][1]  <=   8'b0;
        tug3dout_reg[4][0]  <=   8'b0;
        tug3dout_reg[4][1]  <=   8'b0;
        tug3dout_reg[5][0]  <=   8'b0;
        tug3dout_reg[5][1]  <=   8'b0;
        tug3dout_reg[6][0]  <=   8'b0;
        tug3dout_reg[6][1]  <=   8'b0;
        tug3dout_reg[7][0]  <=   8'b0;
        tug3dout_reg[7][1]  <=   8'b0;
        tug3dout_reg[8][0]  <=   8'b0;
        tug3dout_reg[8][1]  <=   8'b0;
        bip8tug3_reg <= bip8stuff;
        bip8tug3 <= 0;
        for(i=0;i<=8;i=i+1)             //9 rows
            begin
            for(j=2;j<=(COLT3-1);j=j+1)        // col 2 to 85
                begin
                tug3dout_reg[i][j] <= 0;
                end
            end 
        end   
    else if (di_vld&endin)         
        begin
        bip8tug3_reg <= bip8tug3_reg^tug3din;          
        tug3dout_reg[a][b] <=  tug3din;
        b <= b+1;
        if(b == (COLT3-1))
            begin
            b <= 2;
            a <= a+1;       
            if(a == (ROW-1))
                begin               
                bip8tug3 <= bip8tug3_reg;               
                bip8tug3_reg <= bip8tug3_reg;
                empty <= 0;
                a <= 0;
                end
            end
        end    
    end
wire endin; // endin is set when en is high
fflopx #(1) fflopen (clk,!rst,en,endin);
////////////////////////////////////////////////////////////////////////////////
// send data to memory
 
always @(posedge clk)
    begin
    if(rst)
        begin
        tug3dout <= 0;     
        r <= 0;        
        c <= 0;
        bip_vld <= 1;
        end
     else  if(txsof)
        begin
        tug3dout <= 0;     
        r <= 0;        
        c <= 0;
        bip_vld <= 1;
        end
    else if(en&di_vld)         // when length tu12 = 15 , send data to memory
        begin
        tug3dout <= tug3dout_reg [r][c];
        c <= c+1;
        bip_vld <= 0;
        if(c == (COLT3-1))
            begin
            c <= 0;
            r <= r+1;          
            if(r == (ROW-1))
                begin               
                r <= 0;
                bip_vld <= 1;
                end
            end
        end
    else
        begin
        tug3dout <= {WIDTH{0}};
        bip_vld <= bip_vld;
        end
    end
endmodule 
