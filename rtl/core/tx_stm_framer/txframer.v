// Filename     : txframer.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module txframer
    (
     clk19,
     rst,

     wdat,
     en,
     txsof,
     rxsof,
     
     b2dat,
     b2vld,
     m1dat,
     b1dat,
     b1vld
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

output [7:0] wdat;
input        en;
input        rxsof;
input        txsof;

input [23:0] b2dat;
input        b2vld;
input [7:0]  b1dat;
input        b1vld;
input [7:0]  m1dat;
      
////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [7:0]    wdat;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter    INIT = 0;

//RSOH bytes
parameter    A1 = 8'b1111_0110,
             A2 = 8'b0010_1000,
             C1 = 8'b0000_0001,
             E1 = 8'd0,
             F1 = 8'd0,
             D1 = 8'd0,
             D2 = 8'd0,
             D3 = 8'd0;

//MSOH bytes
parameter   K1 = 8'd0,
            K2 = 8'd0,
            D4 = 8'd0,
            D5 = 8'd0,
            D6 = 8'd0,
            D7 = 8'd0,
            D8 = 8'd0,
            D9 = 8'd0,
            D10 = 8'd0,
            D11 = 8'd0,
            D12 = 8'd0,
            S1 = 8'd0,
            E2 = 8'd0;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [6:0]    ptr;

always @(posedge clk19)
    begin
    if (rst || txsof)
        begin
        ptr <= INIT;
        end
    else if (en)
        begin
        if (ptr == 7'd71)
            begin
            ptr <= INIT;
            end
        else
            begin
            ptr <= ptr + 7'd1;
            end
        end
    end

// Send MSOH bytes

reg [7:0] b1;
reg [23:0] b2;
reg [7:0] m1;

always @(*)
    begin
    case(ptr)
        7'd0, 7'd1, 7'd2: wdat  <= A1;  // Frame alignment
        7'd3, 7'd4, 4'd5: wdat  <= A2;  // Frame alignment
        7'd6: wdat  = C1;
        7'd7: wdat  = 8'b10010011;
        7'd8: wdat  = 8'b10010011;  
        7'd9: wdat  = b1;  // BIP-8 of the previous frame
        7'd12: wdat = E1;
        7'd15: wdat = F1;
        7'd18: wdat = D1;
        7'd21: wdat = D2;
        7'd24: wdat = D3;
        7'd27: wdat = b2[23:16];   // BIP-24 of the previous frame
        7'd28: wdat = b2[15:8];    // BIP-24 of the previous frame
        7'd29: wdat = b2[7:0];     // BIP-24 of the previous frame
        7'd30: wdat = K1;          
        7'd33: wdat = K2;  
        7'd36: wdat = D4;
        7'd39: wdat = D5;
        7'd42: wdat = D6;
        7'd45: wdat = D7;
        7'd48: wdat = D8;
        7'd51: wdat = D9;
        7'd54: wdat = D10;
        7'd57: wdat = D11;
        7'd60: wdat = D12;
        7'd63: wdat = S1;
        7'd68: wdat = m1;  //REI
        7'd69: wdat = E2;
        default: wdat   = 8'd0;
    endcase
    end

// Receive BIP-8 and BIP-24

always @(posedge clk19)
    begin
    if (rst)
        begin
        b1  <= INIT;
        b2  <= INIT;
        end
    else
        case({b1vld, b2vld})
            2'b00:  // do nothing
                begin
                b1  <= b1;
                b2  <= b2;
                end
            2'b01:  // receive b2
                begin
                b1  <= b1;
                b2  <= b2dat;
                end
            2'b10:  // receive b1
                begin
                b1  <= b1dat;
                b2  <= b2;
                end
            2'b11:  // receive b1, b2 
                begin
                b1  <= b1dat;
                b2  <= b2dat;
                end
            default:  // do nothing
                begin
                b1  <= b1;
                b2  <= b2;
                end
        endcase
    end

// Receive M1


always @(posedge clk19)
    begin
    if (rst)
        begin
        m1  <= INIT;
        end
    else if (rxsof)
        begin
        m1  <= m1dat;
        end
    end

endmodule 
