// Filename     : tug3_rx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module tug3_rx
    (
     clk,
     rst,
     
     en,     
     rxsof,
     tug3din,
     
     tug3bip8,
     bip_vld,
     
     tug3dout,
     data_vld
     );
parameter WIDTH = 8;
////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk,
      rst;

input en;
input rxsof;
input [WIDTH-1:0] tug3din;

output            data_vld;
output [WIDTH-1:0] tug3dout;
output             bip_vld;
output [WIDTH-1:0] tug3bip8;

////////////////////////////////////////////////////////////////////////////////
// Output declarations
reg                data_vld;
reg [WIDTH-1:0]    tug3dout;
reg [WIDTH-1:0]    tug3bip8;
reg [WIDTH-1:0]    tug3bip8_reg;
reg                bip_vld;
reg [6:0]          col;
reg [3:0]          row;
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
always @(posedge clk)
    begin
    if(rst)
        begin
        tug3dout <= {WIDTH{1'b0}};
        data_vld <= 1'b0;
        tug3bip8 <= {WIDTH{1'b0}};
        tug3bip8_reg <= {WIDTH{0}};
        row <= 7'b0;
        col <= 4'b0;
        bip_vld <= 1'b0; 
        end
    else if(rxsof)
       begin
        tug3dout <= {WIDTH{1'b0}};
        data_vld <= 1'b0;
        tug3bip8 <= {WIDTH{1'b0}};
        tug3bip8_reg <= {WIDTH{0}};
        row <= 7'b0;
        col <= 4'b0;
        bip_vld <= 1'b0; 
       end
    else if(row == 0 & col == 0)
        begin
        tug3bip8_reg <= 0;
        tug3bip8 <= tug3bip8_reg;
        bip_vld <= 1;       
        end        
    else if(en)
        begin
        if(row >=2)
            begin
            tug3dout <= tug3din;
            data_vld <= 1'b1;
            end
        data_vld <= 0;
        tug3bip8_reg <= tug3bip8_reg^tug3din;
        bip_vld <= 0;
        row <= ( row == 8) ? 0:row +1;
        col <= (row == 8)?
               (col == 85)?0:col+7'b1:col;
        end      
    else data_vld <= 0;         
    end
endmodule 
