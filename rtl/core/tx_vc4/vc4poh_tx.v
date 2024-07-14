// Filename     : vc4poh_tx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module vc4poh_tx
    (
     clk,   // clk19
     rst,
     txsof,
     
     dinbip8,   //from tug3_tx
     bip_vld,   //from tug3_tx
     
     rei_bip8,  // from vc4_rx
     rei_vld,   //from vc4_rx
 
     en,  //from mem
     dpoh  // to mem

     );
parameter WIDTH =8;

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input     clk;

input     rst;

input     txsof;

input bip_vld;
input [WIDTH-1:0] dinbip8;        // previus bip8tug

input             rei_vld;
input [3:0]       rei_bip8;

input             en;
output [WIDTH-1:0] dpoh;

////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg [WIDTH-1:0]    dvc4poh [8:0][2:0];
reg [WIDTH-1:0]    dpoh;

reg [1:0]          c;
reg [3:0]          r;
reg [WIDTH-1:0]    g1;

        
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
// calculate B3

wire [WIDTH-1:0]   j1,
                   b3,
                   c2,
                   //g1,
                   f2,
                   f3,
                   h4,
                   k3,
                   n1;

assign             f3 = 8'b0;
assign             b3 = c2^f2^f3^h4^k3^n1;
assign             c2 = 8'b0000_0001;

assign             f2 = 8'b0;
assign             f3 = 8'b0;
assign             h4 = 8'b0;
assign             k3 = 8'b0;
assign             n1 = 8'b0;

// 9 bytes VC4  POH
reg [WIDTH-1:0]    bip8_pre;
reg [WIDTH-1:0]    g1_pre;
// 2 stuff VC4
always @(posedge clk)
    begin
    if(rst)
        begin
        dvc4poh[0] [0]   <=   j1;

        dvc4poh[1][0]    <=   b3;

        dvc4poh[2][0]    <=   c2;

        dvc4poh[3][0]    <=   g1;       // g1 current

        dvc4poh[4][0]    <=   f2;

        dvc4poh[5][0]    <=   h4;

        dvc4poh[6][0]    <=   f3;

        dvc4poh[7][0]    <=   k3;

        dvc4poh[8][0]    <=   n1;
    
        dvc4poh[0][2]    <=   8'b0;   
        dvc4poh[0][1]    <=   8'b0;
        dvc4poh[1][2]    <=   8'b0;
        dvc4poh[1][1]    <=   8'b0;
        dvc4poh[2][2]    <=   8'b0;
        dvc4poh[2][1]    <=   8'b0;
        dvc4poh[3][2]    <=   8'b0;
        dvc4poh[3][1]    <=   8'b0;
        dvc4poh[4][2]    <=   8'b0;
        dvc4poh[4][1]    <=   8'b0;
        dvc4poh[5][2]    <=   8'b0;
        dvc4poh[5][1]    <=   8'b0;
        dvc4poh[6][2]    <=   8'b0;
        dvc4poh[6][1]    <=   8'b0;
        dvc4poh[7][2]    <=   8'b0;
        dvc4poh[7][1]    <=   8'b0;
        dvc4poh[8][2]    <=   8'b0;
        dvc4poh[8][1]    <=   8'b0;  
        
        end
    else if (bip_vld)
        begin 
        dvc4poh[1][0]    <=   b3^bip8_pre^dinbip8; 
        end
    end
////////////////////////////////////////////////////////////////////////////////   
reg fault;  // receive rei after transmit g1;
always @(posedge clk)
    begin
    if(rst)
        begin
        dpoh <= 8'b0;
        bip8_pre <= 0;
        c <= 0;
        r <=0;  
        g1_pre <= 0;
        end
    else if(en)
        begin
        dpoh <= dvc4poh[r][c];
        c <= (c == 2) ? 0 : c+1;
        r <= (c == 2) ? (r == 8 ? 0: r+1) : r;
        bip8_pre <= ( r == 8 ) ? bip8_pre : dvc4poh[1][0]^(g1&{WIDTH{!fault}});
        end                                                                                                                                                     
    end     

always @(posedge clk)
    begin
    if(rst)
        g1 <= 0;
    else if(rei_vld)
        begin
        fault <=0;
        g1 <= {rei_bip8,4'b0};
        if(r>=3)       // if rei received after transmit g1, do not compute
            fault <= 1; // into bip8
        end
     
    end
endmodule 
