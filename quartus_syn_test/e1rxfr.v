// Filename     : e1rxfr.v
// Description  : E1 Rx Framer -- basic frame structure
////////////////////////////////////////////////////////////////////////////////

module e1rxfr
    (
     clk2,  //e1 clock
     clk19, //sys clock
     rst,   //atcive high reset

     //from HDB3
     serin,         //serial input

     //to VC VT
     dataout,            //8 bit data out
     dovld,         //data out valid
     aisdet,        //alarms indicator detect for V5

     //From LIU
     losdet         //loss of signal detect
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   clk19;
input   rst;

input               serin;
output [WID-1:0]    dataout;
output              dovld;
output              aisdet;

input               losdet; 

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter    WID            = 8;
parameter    FAS_PAT        = 7'b0011011; //FAS pattern
parameter    BITPERFRAME    = 8'd255;
parameter    BITPER2FRAME   = 9'd511;

////////////////////////////////////////////////////////////////////////////////
// Logic Instantiation

//shift register
wire [WID-1:0]   serinrg;

fflopx #(WID) serinrgi (clk2,rst,{serinrg[6:0],serin},serinrg);

//State machine
// 2'b00 : search 1st FAS or loss of frame
// 2'b01 : 1st NFAS
// 2'b11 : 2nd FAS
// 2'b10 : inframe
//Note los has higher priority than ais (Cant happen same time)

wire        aiscond;
wire        aisesc;
reg         aisflag; //for ais state

wire        infr;
wire        fasdet, nfasdet;
wire        fr_start;
wire        sof; //start of frame

reg         fr_odd; // odd even for nfas fas
reg [7:0]   bitcnt; //counter 255
reg [1:0]   faserr; //error counter while inframe
reg [1:0]   nfaserr;
reg         dovld1;

reg [1:0]   state;

assign  fasdet  =   (serinrg[7:0] == FAS_PAT);
assign  nfasdet =   serinrg[6];
assign  sof     =   (bitcnt == BITPERFRAME);
assign  aiscond = (&zrbitnum)? 1'b0 :
                  (aiscnt == BITPER2FRAME)? 1'b1 : 1'b0;
assign  aisesc  = fasdet | (&zrbitnum & aiscnt == BITPER2FRAME);

always@(posedge clk2)
    begin
    if(rst)
        begin
        state   <= 2'b00;
        aisflag  <= 1'b0;
        end
    else if(losdet)
        begin
        state   <= 2'b00;//los always lof
        end
    else if(aisflag)
        begin
        aisflag <= !aisesc;
        state   <= 2'b00;
        end
    else
        case(state)
            2'b00:
                begin
                fr_odd  <= 1'b1;//NFAS detect first in sync
                faserr  <= 2'b00;
                bitcnt  <= 8'b0;
                state   <= (fasdet)? 2'b01 : 2'b00;
                aisflag <= aiscond;             
                end
            2'b01:
                begin
                if(sof)
                    state   <= (nfasdet)? 2'b11 : 2'b00;
                else
                    bitcnt  <=  bitcnt + 8'b1;
                aisflag     <= aiscond;
                end
            2'b11:
                begin
                if(sof)
                    state   <=  (fasdet)? 2'b10 : 2'b00;
                else
                    bitcnt  <=  bitcnt + 8'b1;
                aisflag     <= aiscond;
                end
            2'b10:
                begin
                if(sof)
                    begin
                    if(!fr_odd)
                        faserr  <= (fasdet)?    2'b00 : faserr + 2'b1;
                    else
                        nfaserr <= (nfasdet)?   2'b00 : nfaserr + 2'b1;
                    end
                else
                    begin
                    bitcnt  <= bitcnt + 8'b1;
                    end
                aisflag <=  aiscond;
                dovld1  <=  &serinrg[2:0];
                state   <=  (nfaserr == 2'b11)? 2'b00 :
                            (faserr == 2'b11)? 2'b00 : 2'b10;
                end
        endcase
    end//end always
                
//ais counter in bit
                 
reg [1:0]   zrbitnum;
reg [8:0]   aiscnt;//double frame counter 512


always@(posedge clk2)
    begin
    if(rst)
        begin
        zrbitnum <= 2'b00;
        aiscnt  <=  9'b0;
        end
    else
        begin
        aiscnt      <= aiscnt + 9'b1;
        zrbitnum    <= (zrbitnum == 2'b11)? 2'b11 :
                       (aiscnt == BITPER2FRAME)? 2'b00 : zrbitnum + serinrg[0];
        end
    end
////////////////////////////////////////////////////////////////////////////////
//ais out

assign  aisdet = aisflag;

//sync 2 mhz dovld to 19mhz dovld
wire       dovld2, dovld3;

fflopx #(1) ffvld1i(clk19,rst,dovld1,dovld2);
fflopx #(1) ffvld2i(clk19,rst,dovld2,dovld3);

assign     dovld = dovld2;

//send out AIS when ais flagged, data out

assign     dataout = (aisflag)? 8'b11111111 : serinrg[7:0];

endmodule 
