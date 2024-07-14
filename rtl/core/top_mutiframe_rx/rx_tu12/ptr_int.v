// Filename     : ptr_int.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////
module ptr_int
    (
     clk,
     rst,

     din,  // pointer in
     en,  // enable pointer in
     rxsof,  // start of frame
     poffset,
     //inc_ind,
     //dec_ind,
     lop,
     ais
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk;
input rst;
input [7:0] din;
input       en;
input       rxsof;
output [9:0] poffset;
//output      inc_ind;
//output      dec_ind;
output       lop;
output       ais;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg         inc_ind;
reg         dec_ind;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter   NORM = 2'b00,
            LOP = 2'b01,
            AIS = 2'b10;
parameter   MAXOFFSET = 10'd139;
parameter   INIT = 0;


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [7:0] pointer [0:3];
reg [1:0] cnt;  // cnt  pointer

wire [9:0] offset;
assign     offset = {pointer[0][1:0], pointer[1]}; // {v1[1:0],v2}
reg [9:0]  poffset; // previrous offset

wire       equal;
assign     equal = (poffset == offset);

// read frame's pointer
always @(posedge clk19)
    begin
    if (rst)
        begin
        cnt     <= INIT;
        end
    else if (rxsof)
        begin
        cnt     <= INIT;      
        end
    else if (en)
        begin
        pointer[cnt] <= din;
        cnt <= (cnt == 3)?2'b0:cnt + 2'b01;
        end
    end

always @(posedge clk)
    begin
    if(rst) poffset <= INIT;
    else if(rxsof) poffset <= offset;
    else if(inc_ind) poffset <= poffset + 10'd1;
    else if(dec_ind) poffset <= poffset - 10'd1;
    end
// pointer interpretation
reg [1:0] state;
reg [3:0] cntndf; // count n consecutive NDF_enable
reg [1:0] cntnor; // count 3 consecutive norm_point
reg [3:0] cntinv; // count N consecutive inv_point
reg [1:0] cntais; // count 3 consecutive AIS_ind
reg [1:0] cnt3; // count 3 frames 


wire [3:0] ndf; // new data flag
assign     ndf = pointer[0][7:4]; // bit 7_4 of V1
wire       norm_ndf;
assign norm_ndf = ((ndf == 4'b0110) ||
                   (ndf == 4'b1110) ||
                   (ndf == 4'b0010) ||
                   (ndf == 4'b0100) ||
                   (ndf == 4'b0111));

wire   en_ndf;
assign en_ndf = ((ndf == 4'b1001) ||
                 (ndf == 4'b0001) ||
                 (ndf == 4'b1101) ||
                 (ndf == 4'b1011) ||
                 (ndf == 4'b1000));

wire   iinv; // I bits inverted
assign iinv = ((poffset ^ offset) == 10'b1010_1010_10);

wire   dinv; // D bits inverted
assign dinv = ((poffset ^ offset) == 10'b0101_0101_01);

always @(posedge clk)
    begin
    if (rst)
        begin
        inc_ind <= INIT;
        dec_ind <= INIT;
        state   <= INIT;
        cntndf  <= INIT;
        cntinv  <= INIT;
        cntnor  <= INIT;
        cntais  <= INIT;
        cnt3    <= INIT;
        end
    else if (cnt == 2'd2)
        begin
        cntndf  <= INIT;
        cntinv  <= INIT;
        cntnor  <= INIT;
        cntais  <= INIT;  
        inc_ind <= INIT;
        dec_ind <= INIT;
        if (cnt3 != 2'b00) cnt3 <= cnt3 + 2'b01;
        case(state)
            LOP:
                begin
                // norm point
                if (norm_ndf && (offset <= MAXOFFSET))
                    begin
                    if (cntnor == 3'b10)
                        state   <= NORM;
                    else
                        cntnor  <= cntnor + 2'b01;
                    end             
                // AIS_ind
                else if ({pointer[0], pointer[1]} == 16'hffff)
                    begin
                    if (cntais == 2'b10)
                        state   <= AIS;
                    else
                        cntais  <= cntais + 2'b01;
                    end
                end
            AIS:
                begin
                // norm point
                if (norm_ndf && (offset <= MAXOFFSET))
                    begin
                    if (cntnor == 3'b10)
                        state   <= NORM;
                    else
                        cntnor  <= cntnor + 2'b01;
                    end     
                // NDF enable
                else if (en_ndf && (offset <= MAXOFFSET))
                    begin                       
                    state   <= NORM;    
                    cnt3    <= 2'b01; // reset and + 1
                    end     
                // inv_point
                else
                    begin
                    cntinv  <= cntinv + 4'b0001;
                    if (cntinv == 4'd7)
                        state   <= LOP;
                    end
                end
            default: // NORM state
                begin
                // norm_point
                if (norm_ndf && (offset <= MAXOFFSET) && equal)
                    begin
                    if (cntnor == 3'b10)
                        state   <= NORM;
                    else
                        cntnor  <= cntnor + 2'b01;
                    end
                // NDF enable
                else if (en_ndf && (offset <= MAXOFFSET))
                    begin                       
                    state   <= NORM;    
                    cntndf  <= cntndf + 4'b0001;
                    cnt3    <= 2'b01; // reset and + 1
                    if (cntndf == 4'd7)
                        state   <= LOP;
                    end
                // inc_ind
                else if (iinv && (cnt3 == 2'b00))
                    begin
                    cnt3    <= cnt3 + 2'b01;
                    inc_ind <= 1'b1;
                    end
                // dec_ind
                else if (dinv && (cnt3 == 2'b00))
                    begin
                    cnt3    <= cnt3 + 2'b01;
                    dec_ind <= 1'b1;
                    end
                //AIS_ind
                else if ({pointer[0], pointer[1]} == 16'hffff)
                    begin
                    if (cntais == 2'b10)
                        state   <= AIS;
                    else
                        cntais  <= cntais + 2'b01;
                    end
                // inv_point
                else
                    begin
                    cntinv  <= cntinv + 4'b0001;
                    if (cntinv == 4'd7)
                        state   <= LOP;
                    end
                end
        endcase
        end
    else
        begin
        inc_ind <= 1'b0;
        dec_ind <= 1'b0;
        
        end
    end

assign lop = (state == LOP);
assign ais = (state == AIS);

endmodule 

