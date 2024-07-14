// Filename     : ptrgen.v
// Description  : Generate AU-4 pointer
////////////////////////////////////////////////////////////////////////////////

module ptrgen
    (
     clk19,
     rst,

     wdat,
     en,
     txsof
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

output [7:0] wdat;
input        en;
input        txsof;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [7:0]    wdat;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter   H1 = 8'b0110_1010,
            H2 = 8'b0000_1010,
            H3 = 8'b0000_0000,
            Y = 8'b1001_1011;

parameter   INIT = 0;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [3:0]   cnt;

always @(posedge clk19)
    begin
    if (rst || txsof)
        begin
        cnt <= INIT;
        end
    else if (en)
        begin
        cnt <= cnt + 4'd1;
        end
    end

always @(*)
    begin
    case(cnt)
        4'd0: wdat  = H1;
        4'd1: wdat  = Y;
        4'd2: wdat  = Y;
        4'd3: wdat  = H2;
        4'd4: wdat  = 8'hFF;
        4'd5: wdat  = 8'hFF;
        default: wdat   = H3;
    endcase
    end
        
endmodule 
