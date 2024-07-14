// Filename     : ptrmon.v
// Description  : STM-1 Pointer interpretation
////////////////////////////////////////////////////////////////////////////////

module ptrmon
    (
     clk19,
     rst,

     din,
     en,
     rxsof,

     dout,
     vld,
     inc,
     dec,
     lop,
     ais
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;
input [7:0] din;
input       en;
input       rxsof;

output [9:0] dout;
output       vld;
output       inc;
output       dec;
output       lop;
output       ais;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [9:0]    dout;
reg          vld;
reg          inc;
reg          dec;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter   NORM = 2'b00,
            AIS = 2'b01,
            LOP = 2'b10;
parameter   MAXOFFSET = 10'd782;
parameter   INIT = 0;


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [7:0]   au4mem [0:8];
reg [3:0]   cnt; 

wire [9:0]  offset;
assign      offset = {au4mem[0][1:0], au4mem[3]};

wire [9:0]  poffset; // previrous offset
fflopxe #(10) fflopxei (clk19, rst, rxsof, offset, poffset);

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
        au4mem[cnt] <= din;
        cnt <= cnt + 4'b0001;
        end
    end

// pointer interpretation
reg [1:0] state;
reg [3:0] cntndf; // count n consecutive NDF_enable
reg [1:0] cntnor; // count 3 consecutive norm_point
reg [3:0] cntinv; // count N consecutive inv_point
reg [1:0] cntais; // count 3 consecutive AIS_ind
reg [1:0] cnt3; // count 3 frames
reg [9:0] act_offset; // active offset

wire [3:0] ndf; // new data flag
assign     ndf = au4mem[0][7:4];

wire       norm_ndf;
assign norm_ndf = (((ndf == 4'b0110) || (ndf == 4'b1110)) ||
                   ((ndf == 4'b0010) || (ndf == 4'b0100)) ||
                    (ndf == 4'b0111));

wire   ndf_ind; 
assign ndf_ind = (((ndf == 4'b1001) || (ndf == 4'b0001)) ||
                 ((ndf == 4'b1101) || (ndf == 4'b1011)) ||
                 (ndf == 4'b1000));

wire   iinv; // I bits inverted
assign iinv = ((poffset ^ offset) == 10'h2aa); // ^10_1010_1010

wire   dinv; // D bits inverted
assign dinv = ((poffset ^ offset) == 10'h155); // ^01_0101_0101

wire        equal;
assign      equal = (poffset == offset);

wire        norptra;
assign      norptra = ((norm_ndf && (offset <= MAXOFFSET)) && 
                      (offset == act_offset));

wire        ndfen;
assign      ndfen = ndf_ind && (offset <= MAXOFFSET);

wire        inc_ind;
assign      inc_ind = iinv && (cnt3 == 2'b00);

wire        dec_ind;
assign      dec_ind = dinv && (cnt3 == 2'b00);

wire        ais_ind;
assign      ais_ind = ({au4mem[0], au4mem[3]} == 16'hffff);

wire        norptr;
assign norptr = ((norm_ndf && (offset <= MAXOFFSET)) && 
                 equal);

always @(posedge clk19)
    begin
    if (rst)
        begin
        inc     <= INIT;
        dec     <= INIT;
        state   <= LOP;
        cntndf  <= INIT;
        cntinv  <= INIT;
        cntnor  <= INIT;
        cntais  <= INIT;
        cnt3    <= INIT;
        act_offset  <= INIT;
        end
    else if (cnt == 4'd5)
        begin
        cntndf  <= INIT;
        cntinv  <= INIT;
        cntnor  <= INIT;
        cntais  <= INIT;  
        case(state)
            NORM:
                begin
                // norm_point
                if (norptra)
                    begin
                    cntndf  <= INIT;
                    cntinv  <= INIT;
                    cntais  <= INIT;
                    
                    if (cnt3) cnt3 <= cnt3 + 2'b01;
                    if (cntnor == 3'b10)
                        begin
                        state   <= NORM;
                        cntnor  <= INIT;
                        act_offset  <= offset;
                        end
                    else cntnor  <= cntnor + 2'b01;
                    end
                // NDF enable
                else if (ndfen)
                    begin     
                    cntinv  <= INIT;
                    cntnor  <= INIT;
                    cntais  <= INIT;  
                    
                    state   <= NORM;    
                    cntndf  <= cntndf + 4'b0001;
                    cnt3    <= 2'b01; // reset and + 1
                    act_offset  <= offset;
                    if (cntndf == 4'd7)
                        begin
                        state   <= LOP;
                        cntndf  <= INIT;
                        end
                    end
                // inc_ind
                else if (inc_ind)
                    begin
                    cntndf  <= INIT;
                    cntinv  <= INIT;
                    cntnor  <= INIT;
                    cntais  <= INIT; 
                    
                    cnt3    <= cnt3 + 2'b01;
                    inc     <= 1'b1;
                    act_offset  <= act_offset + 1;
                    end
                // dec_ind
                else if (dec_ind)
                    begin
                    cntndf  <= INIT;
                    cntinv  <= INIT;
                    cntnor  <= INIT;
                    cntais  <= INIT; 
                    
                    cnt3    <= cnt3 + 2'b01;
                    dec     <= 1'b1;
                    act_offset  <= act_offset - 1;
                    end
                //AIS_ind
                else if (ais_ind)
                    begin
                    cntndf  <= INIT;
                    cntinv  <= INIT;
                    cntnor  <= INIT;
                    
                    if (cnt3) cnt3 <= cnt3 + 2'b01;
                    if (cntais == 2'b10)
                        begin
                        state   <= AIS;
                        cntais  <= INIT;
                        end
                    else cntais  <= cntais + 2'b01;
                    end
                // inv_point
                else
                    begin
                    cntndf  <= INIT;
                    cntnor  <= INIT;
                    cntais  <= INIT; 
                    
                    if (cnt3) cnt3 <= cnt3 + 2'b01;
                    if (cntinv == 4'd7) 
                        begin
                        state   <= LOP;
                        cntinv  <= INIT;
                        end
                    else cntinv <= cntinv + 4'b001;
                    end
                end
            
            AIS:
                begin
                // norm point
                if (norptr)
                    begin
                    cntinv  <= INIT;                
                    if (cntnor == 3'b01)
                        begin
                        state   <= NORM;
                        cntnor  <= INIT;
                        act_offset  <= offset;
                        end
                    else cntnor  <= cntnor + 2'b01;
                    end     
                // NDF enable
                else if (ndfen)
                    begin        
                    cntnor  <= INIT;
                    cntinv  <= INIT;                                   
                    state   <= NORM;    
                    cnt3    <= 2'b01; // reset and + 1
                    act_offset  <= offset;
                    end     
                // inv_point
                else
                    begin
                    cntnor  <= INIT;                    
                    if (cntinv == 4'd7) 
                        begin
                        state   <= LOP;
                        cntinv  <= INIT;
                        end
                    else cntinv <= cntinv + 4'b001;
                    end
                end
            
            default: // LOP
                begin
                // norm point
                if (norptr)
                    begin
                    cntinv  <= INIT;                    
                    if (cntnor == 3'b10)
                        begin
                        state   <= NORM;
                        cntnor  <= INIT;
                        act_offset  <= offset;
                        end
                    else cntnor  <= cntnor + 2'b01;
                    end             
                // AIS_ind
                else if (ais_ind)
                    begin
                    cntnor  <= INIT;                    
                    if (cntais == 2'b10) 
                        begin
                        state   <= AIS;
                        cntais  <= INIT;
                        end
                    else cntais  <= cntais + 2'b01;
                    end
                end
        endcase
        end
    else
        begin
        inc <= INIT;
        dec <= INIT;
        end
    end

always @(posedge clk19)
    begin
    if (rst)
        begin
        dout    <= INIT;
        vld     <= INIT;
        end
    else if (cnt == 4'd5)
        begin
        if (inc_ind)
            begin
            dout    <= (offset ^ iinv) + 1;
            vld     <= 1'b1;
            end
        else if (dec_ind)
            begin
            dout    <= (offset ^ dinv) + 1;
            vld     <= 1'b1;
            end
        else
            begin
            dout    <= offset;
            vld     <= 1'b1;
            end
        end
    else
        begin
        dout    <= dout;
        vld     <= INIT;
        end
    end
    
assign lop = (state == LOP);
assign ais = (state == AIS);


endmodule 
