// Filename     : e1datamux.v
// Description  : data mux for 21 e1 channel
////////////////////////////////////////////////////////////////////////////////

module e1datamux
    (
     clk, //@clk19
     rst,

     //data from 21 E1 channel
     di1,
     di2,
     di3,
     di4,
     di5,
     di6,
     di7,
     di8,
     di9,
     di10,
     di11,
     di12,
     di13,
     di14,
     di15,
     di16,
     di17,
     di18,
     di19,
     di20,
     di21,

     //vld from 21 E1 channel @clk19
     vld1,
     vld2,
     vld3,
     vld4,
     vld5,
     vld6,
     vld7,
     vld8,
     vld9,
     vld10,
     vld11,
     vld12,
     vld13,
     vld14,
     vld15,
     vld16,
     vld17,
     vld18,
     vld19,
     vld20,
     vld21,
     
     oid, //chanel ID
     do, //data out
     dovld //data out valid
     
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter        WID = 8;

localparam       CHNBIT = 5; //number of bit needed for 21 channel
localparam       NCHANEL = 21;
localparam       RESETVALUE = 0;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk;
input rst;

input [WID-1:0] di1;
input [WID-1:0] di2;
input [WID-1:0] di3;
input [WID-1:0] di4;
input [WID-1:0] di5;
input [WID-1:0] di6;
input [WID-1:0] di7;
input [WID-1:0] di8;
input [WID-1:0] di9;
input [WID-1:0] di10;
input [WID-1:0] di11;
input [WID-1:0] di12;
input [WID-1:0] di13;
input [WID-1:0] di14;
input [WID-1:0] di15;
input [WID-1:0] di16;
input [WID-1:0] di17;
input [WID-1:0] di18;
input [WID-1:0] di19;
input [WID-1:0] di20;
input [WID-1:0] di21;

input           vld1;
input           vld2;
input           vld3;
input           vld4;
input           vld5;
input           vld6;
input           vld7;
input           vld8;
input           vld9;
input           vld10;
input           vld11;
input           vld12;
input           vld13;
input           vld14;
input           vld15;
input           vld16;
input           vld17;
input           vld18;
input           vld19;
input           vld20;
input           vld21;

output [CHNBIT-1:0]    oid;
output [WID-1:0]       do;
output                 dovld;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

//channel id counter

reg [CHNBIT:0]       chcnt;

always@(posedge clk)
    begin
    if(rst)
        begin
        chcnt <= RESETVALUE;
        end
    else
        begin
        chcnt <= (chcnt == 5'd20)? RESETVALUE : chcnt + 5'd1;
        end
    end

// channel valid register and clear

reg [NCHANEL-1:0] chvld;
reg [NCHANEL-1:0] clear;//note

always@(posedge clk)
    begin
    if(rst)
        begin
        chvld <= RESETVALUE;
        end
    else
        begin
        chvld[0]  <= (!chvld[0] & vld1)?    1'b1 :
                     (chvld[0] & clear[0])? 1'b0 : chvld[0];
        chvld[1]  <= (!chvld[1] & vld2)?    1'b1 :
                     (chvld[1] & clear[1])? 1'b0 : chvld[1];
        chvld[2]  <= (!chvld[2] & vld3)?    1'b1 :
                     (chvld[2] & clear[2])? 1'b0 : chvld[2];
        chvld[3]  <= (!chvld[3] & vld4)?    1'b1 :
                     (chvld[3] & clear[3])? 1'b0 : chvld[3];
        chvld[4]  <= (!chvld[4] & vld5)?    1'b1 :
                     (chvld[4] & clear[4])? 1'b0 : chvld[4];
        chvld[5]  <= (!chvld[5] & vld6)?    1'b1 :
                     (chvld[5] & clear[5])? 1'b0 : chvld[5];
        chvld[6]  <= (!chvld[6] & vld7)?    1'b1 :
                     (chvld[6] & clear[6])? 1'b0 : chvld[6];
        chvld[7]  <= (!chvld[7] & vld8)?    1'b1 :
                     (chvld[7] & clear[7])? 1'b0 : chvld[7];
        chvld[8]  <= (!chvld[8] & vld9)?    1'b1 :
                     (chvld[8] & clear[8])? 1'b0 : chvld[8];
        chvld[9]  <= (!chvld[9] & vld10)?   1'b1 :
                     (chvld[9] & clear[9])? 1'b0 : chvld[9];
        chvld[10] <= (!chvld[10] & vld11)?    1'b1 :
                     (chvld[10] & clear[10])? 1'b0 : chvld[10];
        chvld[11] <= (!chvld[11] & vld12)?    1'b1 :
                     (chvld[11] & clear[11])? 1'b0 : chvld[11];
        chvld[12] <= (!chvld[12] & vld13)?    1'b1 :
                     (chvld[12] & clear[12])? 1'b0 : chvld[12];
        chvld[13] <= (!chvld[13] & vld14)?    1'b1 :
                     (chvld[13] & clear[13])? 1'b0 : chvld[13];
        chvld[14] <= (!chvld[14] & vld15)?    1'b1 :
                     (chvld[14] & clear[14])? 1'b0 : chvld[14];
        chvld[15] <= (!chvld[15] & vld16)?    1'b1 :
                     (chvld[15] & clear[15])? 1'b0 : chvld[15];
        chvld[16] <= (!chvld[16] & vld17)?    1'b1 :
                     (chvld[16] & clear[16])? 1'b0 : chvld[16];
        chvld[17] <= (!chvld[17] & vld18)?    1'b1 :
                     (chvld[17] & clear[17])? 1'b0 : chvld[17];
        chvld[18] <= (!chvld[18] & vld19)?    1'b1 :
                     (chvld[18] & clear[18])? 1'b0 : chvld[18];
        chvld[19] <= (!chvld[19] & vld20)?    1'b1 :
                     (chvld[19] & clear[19])? 1'b0 : chvld[19];
        chvld[20] <= (!chvld[20] & vld21)?    1'b1 :
                     (chvld[20] & clear[20])? 1'b0 : chvld[20];
        end
    end

//memory for data

reg [WID-1:0] ram [NCHANEL-1:0];

always@(posedge clk)
    begin
    ram[0] <= vld1? di1 : ram[0];
    ram[1] <= vld2? di2 : ram[1];
    ram[2] <= vld3? di3 : ram[2];
    ram[3] <= vld4? di4 : ram[3];
    ram[4] <= vld5? di5 : ram[4];
    ram[5] <= vld6? di6 : ram[5];
    ram[6] <= vld7? di7 : ram[6];
    ram[7] <= vld8? di8 : ram[7];
    ram[8] <= vld9? di9 : ram[8];
    ram[9] <= vld10? di10 : ram[9];
    ram[10] <= vld11? di11 : ram[10];
    ram[11] <= vld12? di12 : ram[11];
    ram[12] <= vld13? di13 : ram[12];
    ram[13] <= vld14? di14 : ram[13];
    ram[14] <= vld15? di15 : ram[14];
    ram[15] <= vld16? di16 : ram[15];
    ram[16] <= vld17? di17 : ram[16];
    ram[17] <= vld18? di18 : ram[17];
    ram[18] <= vld19? di19 : ram[18];
    ram[19] <= vld20? di20 : ram[19];
    ram[20] <= vld21? di21 : ram[20];
    end

//Control logic

reg [CHNBIT-1:0] oid;
reg [WID-1:0]    do;
reg              dovld;

always@(posedge clk)
    begin
    if(rst)
        begin
        do <= RESETVALUE;
        dovld <= RESETVALUE;
        end
    else
        begin
        oid     <= chcnt;
        do      <= ram[chcnt];
        dovld   <= chvld[chcnt];
        end
    end

//Clearing valid logic

always@(posedge clk)
    begin
    if(rst)
        begin
        clear <= RESETVALUE;
        end
    else
        clear <= 1<<chcnt;
    end

////////////////////////////////////////////////////////////////////////////////
// For simulation
integer i;
initial begin for(i=0;i<NCHANEL;i=i+1) ram[i] = {WID{1'b0}}; end

endmodule 
