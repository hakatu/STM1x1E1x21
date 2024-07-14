// Filename     : rwrccnt.v
// Description  : read write row column counter
////////////////////////////////////////////////////////////////////////////////

module rwrccnt
    (
     clk19,
     rst,

     rxsof,
     
     row,
     col,
     sts,
     
     inc,// from AU4
     dec
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter RWID = 4,
          CWID = 7,
          SWID = 2,
          MAXROW = 9,
          MAXCOL = 90,
          MAXSTS = 3,
          RESETVALUE = 0;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

input rxsof;

output [RWID-1:0] row;
output [CWID-1:0] col;
output [SWID-1:0] sts;

input             inc;
input             dec;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [RWID-1:0]    row;
reg [CWID-1:0]    col;
reg [SWID-1:0]    sts;
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [2:0]         cnt; // count bytes since inc

always@(posedge clk19)
    begin
    if(rst)
        begin
        row <= RESETVALUE;
        col <= RESETVALUE;
        sts <= RESETVALUE;
        cnt <= RESETVALUE;
        end
    else if (rxsof)
        begin
        row <= RESETVALUE;
        col <= 7'd3;
        sts <= RESETVALUE;
        cnt <= RESETVALUE;
        end
    else
        begin
        cnt <= ((inc && !dec) || (cnt))? cnt + 1: cnt;
        
        row <= (col == MAXCOL-1)?
               (sts == MAXSTS-1)?
               (row == MAXROW-1)? RESETVALUE : row + 1 : row : row;
        
        
        col <= (sts == MAXSTS-1)? 
               (col == MAXCOL-1)? RESETVALUE : col + 1 :
               (dec && !inc)? col + 1: // next 3 bytes is data
               ((cnt >= 3'd3) && (cnt <= 3'd5))? col : col; // ignore dummy info
             
        sts <= (sts == MAXSTS-1)? RESETVALUE:sts + 1;
        end
    end

endmodule 
