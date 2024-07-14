// Filename     : e1rxfr.v
// Description  : E1 Rx Framer -- basic frame structure
////////////////////////////////////////////////////////////////////////////////

module e1rxfr
    (
     clk2,  //e1 clock
     clk19, //sys clock
     rst,   //atcive high reset

     //from HDB3
     serin,         //serial input @clk2

     //to VC VT
     dataout,            //8 bit data out
     dovld,         //data out valid @clk19

     //From LIU
     losdet,         //loss of signal detect

     //to upi
     crcerr, //crc error block indicator @clk19
     //crcerrsec //number of crc error per sec
     crcmfa //pulse for crc mfa detect
     );


////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter    WID            = 8;
parameter    FAS_PAT        = 7'b0011011; //FAS pattern
parameter    BITPERFRAME    = 8'd255;
parameter    BITPER2FRAME   = 9'd511;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   clk19;
input   rst;

input               serin;
output [WID-1:0]    dataout;
output              dovld;

input               losdet;

output              crcerr;
//output [9:0]        crcerrsec;
output              crcmfa;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

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

//ais counter in bit
                 
reg [1:0]   zrbitnum;
reg [8:0]   aiscnt;//double frame counter 512

wire        fasdet, nfasdet;
wire        sof; //start of frame

reg         fr_odd; // odd even for nfas fas
reg [7:0]   bitcnt; //counter 255
reg [1:0]   faserr; //error counter while inframe
reg [1:0]   nfaserr;
reg         dovld1;//valid @clk2

reg [1:0]   state;

assign  fasdet  =   (serinrg[6:0] == FAS_PAT);
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
        aisflag <= 1'b0;
        bitcnt  <= 8'b0;
        faserr  <= 2'b00;
        nfaserr <= 2'b00;
        fr_odd  <= 1'b0;
        dovld1  <= 1'b0;
        end
    else
        begin
        if(losdet)
            begin
            state   <= 2'b00;//los always lof
            //bitcnt  <= bitcnt + 8'b1;
            end
        else if(aisflag)
            begin
            aisflag <= !aisesc;
            state   <= 2'b00;
            //bitcnt  <= bitcnt + 8'b1;
            end
        else
            case(state)
                2'b00:
                    begin
                    fr_odd  <= 1'b1;//NFAS detect first in sync
                    faserr  <= 2'b00;
                    nfaserr <= 2'b00;
                    //bitcnt  <= 8'b0;
                    state   <= (fasdet)? 2'b01 : 2'b00;
                    //bitcnt  <= (fasdet)? 8'b0  : bitcnt + 8'b1;
                    aisflag <= aiscond;             
                    end
                2'b01:
                    begin
                    if(sof)
                        state   <= nfasdet? 2'b11 :
                                   fasdet?  2'b01 : 2'b00;
                    //bitcnt  <=  bitcnt + 8'b1;
                    aisflag     <= aiscond;
                    end
                2'b11:
                    begin
                    if(sof)
                        state   <=  (fasdet)? 2'b10 : 2'b00;
                    //bitcnt  <=  bitcnt + 8'b1;
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
                        fr_odd <= !fr_odd;
                        end
                    //else
                        //begin
                        //bitcnt  <= bitcnt + 8'b1;
                        //end
                    aisflag <=  aiscond;
                    //dovld1  <=  &serinrg[2:0];
                    state   <=  (nfaserr == 2'b11)? 2'b00 :
                                (faserr == 2'b11)? 2'b00 : 2'b10;
                    end
            endcase
        dovld1  <=  bitcnt[2:0] == 3'b110;//vld set here to send AIS
        bitcnt  <=  ((state == 2'b00) & fasdet)? 8'b0 : bitcnt + 8'b1; //fixed here 2nd time
        end//end else
    end//end always
                

//aiscounter

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
                       (aiscnt == BITPER2FRAME)? 2'b00 : zrbitnum + !serinrg[0];
        end
    end

//CRC modules

wire       infr;//sof when in frame
wire       sofinfr;
wire      newsmf;

//CRC calculator

wire [3:0] crc;
wire       dicrc;
wire       icrc3,icrc4;
wire       crcrst;

fflopx #(4) ffcrci(clk2,crcrst,{crc[1],crc[2],icrc3,icrc4},crc);

assign     icrc4 = crc[0] ^ dicrc;
assign     icrc3 = crc[3] ^ icrc4;
assign     crcrst = rst | (state == 2'b11 & sof) | newsmf;

//modify crc bits to 0 before calculation

assign     dicrc = (sof & !fr_odd)? 1'b0 : serinrg[7];
//start to cal when sof found and crcrst off

//CRC cal register

reg [7:0] crcrg;

always@(posedge clk2)
    begin
    if(rst | !infr)
        crcrg <= 8'b0;
    else if(newsmf)
        begin
        crcrg[3:0] <= crc;
        crcrg[7:4] <= crcrg[3:0];
        end
    end

//CRC Multifr alignment signal slider

reg [4:0]  crcsli;
wire       smfdet;//submultiframe alignment found at fr no 11


assign     smfdet   = {crcsli[4:0],serinrg[7]} == 6'b001011;
assign     infr     = (state == 2'b10);
assign     sofinfr  = infr & sof;

always@(posedge clk2)
    begin
    if(rst | !infr)
        crcsli <= 5'b00000;
    else if(sofinfr & fr_odd)
        crcsli <= {crcsli[3:0],serinrg[7]};
    end

//Frame number counter

reg [2:0] crcfrno; // frame number in multi frame

assign    newsmf = (crcfrno == 3'b111) & sof;

always@(posedge clk2)
    begin
    if(rst | !infr)
        crcfrno <= 3'b0;
    else if(sofinfr)
        crcfrno <= (smfdet)? 3'd4 : crcfrno + 3'd1;
    end

//current crc extractor

reg [3:0] curcrc;

always@(posedge clk2)
    begin
    if(rst | !infr)
        curcrc <= 4'b0000;
    else if(sofinfr & !fr_odd)
        case(crcfrno)
            3'd7 : curcrc[0] <= serinrg[7];
            3'd1 : curcrc[1] <= serinrg[7];
            3'd3 : curcrc[2] <= serinrg[7];
            3'd5 : curcrc[3] <= serinrg[7];
        endcase
    end

//crc compare and output

//assert or deassert at frame no 0

wire crcerr1; //crcerr @clk2

assign crcerr1 = (newsmf)? (curcrc != crcrg[7:4]) : 1'b0;

//sync 2 mhz crcerr to 19mhz crcerr posedge detection
wire       metacrc,crcerr2, crcerr3;

fflopx #(1) ffcrc1i(clk19,rst,crcerr1,metacrc);
fflopx #(1) ffcrc2i(clk19,rst,metacrc,crcerr2);
fflopx #(1) ffcrc3i(clk19,rst,crcerr2,crcerr3);

assign     crcerr = !crcerr3 & crcerr2;

//Submultiframe alignment detect sync to clk19

wire       crcmfa1;

assign     crcmfa1 = sofinfr & smfdet;

wire       metamfa,crcmfa2,crcmfa3;

fflopx #(1) ffmfa1i(clk19,rst,crcmfa1,metamfa);
fflopx #(1) ffmfa2i(clk19,rst,metamfa,crcmfa2);
fflopx #(1) ffmfa3i(clk19,rst,crcmfa2,crcmfa3);

assign     crcmfa = !crcmfa3 & crcmfa2;
        
////////////////////////////////////////////////////////////////////////////////
//ais out

assign  aisdet = (state != 2'b10)? 1'b1 : 1'b0; //AIS when not sync

//sync 2 mhz dovld to 19mhz dovld posedge detection
wire       metavld,dovld2, dovld3;

fflopx #(1) ffvld1i(clk19,rst,dovld1,metavld);
fflopx #(1) ffvld2i(clk19,rst,metavld,dovld2);
fflopx #(1) ffvld3i(clk19,rst,dovld2,dovld3);

assign     dovld = !dovld3 & dovld2;

//send out AIS when ais flagged, data out

wire       maskcond;//avoid ais masking first fas

assign     maskcond = aisdet & !((state == 2'b11) & fasdet & sof);

assign     dataout = maskcond? 8'b1111_1111 : serinrg[7:0];

endmodule 
