// Filename     : vc4poh_rx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module vc4poh_rx
    (
     clk,  // clk19
     rst,
     rxsof,
     en,    // from mem
     dpohin,    // from mem
     
     tug3bip8,  // from tug3_rx
     bip_vld,   // from tug3_rx
     
     rei_bip8,  // to vc4poh_tx
     rei_vld    // to vc4poh_tx

     );
parameter         WIDTH =8;
////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst;
input rxsof;
input en;
input [WIDTH-1:0] dpohin;
input             bip_vld;
input [WIDTH-1:0] tug3bip8;
output [3:0]      rei_bip8;
output            rei_vld;
////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg [WIDTH-1:0]   b3;
reg [WIDTH-1:0]   bip8_reg;
reg [WIDTH-1:0]   bip_poh;
reg [3:0]         row;
reg [1:0]         col;
reg               rei_vld;
////////////////////////////////////////////////////////////////////////////////
// Parameter declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
always @(posedge clk)
    begin
    if(rst)
        begin
        bip8_reg <= 0;
        bip_poh <= 0;
        row <= 0;
        col <= 0;
        b3 <= 0;
        end    
    else if (rxsof)
        begin
        bip8_reg <= 0;
        bip_poh <= 0;
        row <= 0;
        b3 <= 0;
        end
    else if( (row == 0) & (col == 0))
        begin
        bip8_reg <= bip_poh;
        bip_poh <= 0;
        b3 <= 0;
        rei_vld <= 0;   // reset rei valid
        end            
    else if(en)
        begin
        bip_poh <= bip_poh^dpohin;
        row <= (row == 8)?0:row + 1;
        col <= (row == 8)?
               (col == 2)? 0: col +1:col;
        if(row == 2 & col == 0)
            begin
            b3 <= dpohin;
            rei_vld <= 1;
            end
        end        
    end
reg [WIDTH-1:0] bip8;
always @(posedge clk)
    begin
    if(rst)
        begin
        bip8 <= 0;
        end
    else if(bip_vld)
        begin
        bip8 <= tug3bip8^bip8_reg;
        end 
    end

assign rei_bip8 = (b3[0]^bip8[0])+
                  (b3[1]^bip8[1])+
                  (b3[2]^bip8[2])+
                  (b3[3]^bip8[3])+
                  (b3[4]^bip8[4])+
                  (b3[5]^bip8[5])+
                  (b3[6]^bip8[6])+
                  (b3[7]^bip8[7]);
endmodule 
