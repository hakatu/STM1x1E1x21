// Filename     : rtlcore.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////
`define RTL_SIMULATION

module rtlcore
    (
     clk19, //19.44 MHz system clock
     clk2, //2.048 MHz E1 clock
     clk155,//155.52 MHz STM-1 clock
     rst, //system reset

     rxdp1, // HDB3 rx channel 1
     rxdn1,
     rxclk1,
     los1,

     rxdp2, // HDB3 rx channel 2
     rxdn2,
     rxclk2,
     los2,
     
     rxdp3, // HDB3 rx channel 3
     rxdn3,
     rxclk3,
     los3,
     
     rxdp4, // HDB3 rx channel 4
     rxdn4,
     rxclk4,
     los4,
     
     rxdp5, // HDB3 rx channel 5
     rxdn5,
     rxclk5,
     los5,
     
     rxdp6, // HDB3 rx channel 6
     rxdn6,
     rxclk6,
     los6,
     
     rxdp7, // HDB3 rx channel 7
     rxdn7,
     rxclk7,
     los7,
     
     rxdp8, // HDB3 rx channel 8
     rxdn8,
     rxclk8,
     los8,
     
     rxdp9, // HDB3 rx channel 9
     rxdn9,
     rxclk9,
     los9,
     
     rxdp10, // HDB3 rx channel 10
     rxdn10,
     rxclk10,
     los10,
     
     rxdp11, // HDB3 rx channel 11
     rxdn11,
     rxclk11,
     los11,
     
     rxdp12, // HDB3 rx channel 12
     rxdn12,
     rxclk12,
     los12,
     
     rxdp13, // HDB3 rx channel 13
     rxdn13,
     rxclk13,
     los13,
     
     rxdp14, // HDB3 rx channel 14
     rxdn14,
     rxclk14,
     los14,
     
     rxdp15, // HDB3 rx channel 15
     rxdn15,
     rxclk15,
     los15,
     
     rxdp16, // HDB3 rx channel 16
     rxdn16,
     rxclk16,
     los16,
     
     rxdp17, // HDB3 rx channel 17
     rxdn17,
     rxclk17,
     los17,
     
     rxdp18, // HDB3 rx channel 18
     rxdn18,
     rxclk18,
     los18,
     
     rxdp19, // HDB3 rx channel 19
     rxdn19,
     rxclk19,
     los19,
     
     rxdp20, // HDB3 rx channel 20
     rxdn20,
     rxclk20,
     los20,
     
     rxdp21, // HDB3 rx channel 21
     rxdn21,
     rxclk21,
     los21,
     
     txdp1, // HDB3 tx channel 1
     txdn1,
     txclk1,

     txdp2, // HDB3 tx channel 2
     txdn2,
     txclk2,

     txdp3, // HDB3 tx channel 3
     txdn3,
     txclk3,

     txdp4, // HDB3 tx channel 4
     txdn4,
     txclk4,

     txdp5, // HDB3 tx channel 5
     txdn5,
     txclk5,

     txdp6, // HDB3 tx channel 6
     txdn6,
     txclk6,

     txdp7, // HDB3 tx channel 7
     txdn7,
     txclk7,
     
     txdp8, // HDB3 tx channel 8
     txdn8,
     txclk8,

     txdp9, // HDB3 tx channel 9
     txdn9,
     txclk9,

     txdp10, // HDB3 tx channel 10
     txdn10,
     txclk10,

     txdp11, // HDB3 tx channel 11
     txdn11,
     txclk11,

     txdp12, // HDB3 tx channel 12
     txdn12,
     txclk12,

     txdp13, // HDB3 tx channel 13
     txdn13,
     txclk13,

     txdp14, // HDB3 tx channel 14
     txdn14,
     txclk14,

     txdp15, // HDB3 tx channel 15
     txdn15,
     txclk15,
     
     txdp16, // HDB3 tx channel 16
     txdn16,
     txclk16,

     txdp17, // HDB3 tx channel 17
     txdn17,
     txclk17,

     txdp18, // HDB3 tx channel 18
     txdn18,
     txclk18,

     txdp19, // HDB3 tx channel 19
     txdn19,
     txclk19,

     txdp20, // HDB3 tx channel 20
     txdn20,
     txclk20,

     txdp21, // HDB3 tx channel 21
     txdn21,
     txclk21,    

     txstm1, // Transmit STM-1
     rxstm1 // Receive STM-1
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter WID = 8;
parameter CWID = 7;
parameter SWID = 2;
parameter RWID = 4;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input clk2;
input clk155;
input rst;

input rxdp1; // HDB3 rx channel 1
input rxdn1;
input rxclk1;
input los1;

input rxdp2; // HDB3 rx channel 2
input rxdn2;
input rxclk2;
input los2;

input rxdp3; // HDB3 rx channel 3
input rxdn3;
input rxclk3;
input los3;

input rxdp4; // HDB3 rx channel 4
input rxdn4;
input rxclk4;
input los4;

input rxdp5; // HDB3 rx channel 5
input rxdn5;
input rxclk5;
input los5;

input rxdp6; // HDB3 rx channel 6
input rxdn6;
input rxclk6;
input los6;

input rxdp7; // HDB3 rx channel 7
input rxdn7;
input rxclk7;
input los7;

input rxdp8; // HDB3 rx channel 8
input rxdn8;
input rxclk8;
input los8;

input rxdp9; // HDB3 rx channel 9
input rxdn9;
input rxclk9;
input los9;

input rxdp10; // HDB3 rx channel 10
input rxdn10;
input rxclk10;
input los10;

input rxdp11; // HDB3 rx channel 11
input rxdn11;
input rxclk11;
input los11;

input rxdp12; // HDB3 rx channel 12
input rxdn12;
input rxclk12;
input los12;

input rxdp13; // HDB3 rx channel 13
input rxdn13;
input rxclk13;
input los13;

input rxdp14; // HDB3 rx channel 14
input rxdn14;
input rxclk14;
input los14;

input rxdp15; // HDB3 rx channel 15
input rxdn15;
input rxclk15;
input los15;

input rxdp16; // HDB3 rx channel 16
input rxdn16;
input rxclk16;
input los16;

input rxdp17; // HDB3 rx channel 17
input rxdn17;
input rxclk17;
input los17;

input rxdp18; // HDB3 rx channel 18
input rxdn18;
input rxclk18;
input los18;

input rxdp19; // HDB3 rx channel 19
input rxdn19;
input rxclk19;
input los19;

input rxdp20; // HDB3 rx channel 20
input rxdn20;
input rxclk20;
input los20;

input rxdp21; // HDB3 rx channel 21
input rxdn21;
input rxclk21;
input los21;

output txdp1; // HDB3 tx channel 1
output txdn1;
output txclk1;

output txdp2; // HDB3 tx channel 2
output txdn2;
output txclk2;

output txdp3; // HDB3 tx channel 3
output txdn3;
output txclk3;

output txdp4; // HDB3 tx channel 4
output txdn4;
output txclk4;

output txdp5; // HDB3 tx channel 5
output txdn5;
output txclk5;

output txdp6; // HDB3 tx channel 6
output txdn6;
output txclk6;

output txdp7; // HDB3 tx channel 7
output txdn7;
output txclk7;

output txdp8; // HDB3 tx channel 8
output txdn8;
output txclk8;

output txdp9; // HDB3 tx channel 9
output txdn9;
output txclk9;

output txdp10; // HDB3 tx channel 10
output txdn10;
output txclk10;

output txdp11; // HDB3 tx channel 11
output txdn11;
output txclk11;

output txdp12; // HDB3 tx channel 12
output txdn12;
output txclk12;

output txdp13; // HDB3 tx channel 13
output txdn13;
output txclk13;

output txdp14; // HDB3 tx channel 14
output txdn14;
output txclk14;

output txdp15; // HDB3 tx channel 15
output txdn15;
output txclk15;

output txdp16; // HDB3 tx channel 16
output txdn16;
output txclk16;

output txdp17; // HDB3 tx channel 17
output txdn17;
output txclk17;

output txdp18; // HDB3 tx channel 18
output txdn18;
output txclk18;

output txdp19; // HDB3 tx channel 19
output txdn19;
output txclk19;

output txdp20; // HDB3 tx channel 20
output txdn20;
output txclk20;

output txdp21; // HDB3 tx channel 21
output txdn21;
output txclk21;    

output txstm1;
input  rxstm1;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Signal declarations

////////////////////////////////////////////////////////////////////////////////
//E1 Local logic and instantiation

wire   serin1;
wire   serout1;

hdb3wrapped hdb3wrapped1i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp1), //positive and negative line
     .rneg(rxdn1),
     .rclk(rxclk1),

     //to LIU
     .tpos(txdp1),
     .tneg(txdn1),

     //framer
     .serin(serout1), //serial //fromframer
     .serout(serin1), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do1;
wire           vld1;
wire [WID-1:0] di1;
wire           endi1;

e1frwrapped #(WID) e1frwrapped1i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin1), // from HDB3
     .serout(serout1),//to hdb3

     .rclk(rxclk1), //from rx LIU
     
     //to data mux
     .dataout(do1),
     .dovld(vld1),//@clk19

     //from VC VT
     .datain(di1),
     .endi19(endi1),//@clk19

     //from LIU
     .los(los1),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin2;
wire   serout2;

hdb3wrapped hdb3wrapped2i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp2), //positive and negative line
     .rneg(rxdn2),
     .rclk(rxclk2),

     //to LIU
     .tpos(txdp2),
     .tneg(txdn2),

     //framer
     .serin(serout2), //serial //fromframer
     .serout(serin2), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do2;
wire           vld2;
wire [WID-1:0] di2;
wire           endi2;

e1frwrapped #(WID) e1frwrapped2i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin2), // from HDB3
     .serout(serout2),//to hdb3

     .rclk(rxclk2), //from rx LIU
     
     //to data mux
     .dataout(do2),
     .dovld(vld2),//@clk19

     //from VC VT
     .datain(di2),
     .endi19(endi2),//@clk19

     //from LIU
     .los(los2),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin3;
wire   serout3;

hdb3wrapped hdb3wrapped3i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp3), //positive and negative line
     .rneg(rxdn3),
     .rclk(rxclk3),

     //to LIU
     .tpos(txdp3),
     .tneg(txdn3),

     //framer
     .serin(serout3), //serial //fromframer
     .serout(serin3), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do3;
wire           vld3;
wire [WID-1:0] di3;
wire           endi3;

e1frwrapped #(WID) e1frwrapped3i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin3), // from HDB3
     .serout(serout3),//to hdb3

     .rclk(rxclk3), //from rx LIU
     
     //to data mux
     .dataout(do3),
     .dovld(vld3),//@clk19

     //from VC VT
     .datain(di3),
     .endi19(endi3),//@clk19

     //from LIU
     .los(los3),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin4;
wire   serout4;

hdb3wrapped hdb3wrapped4i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp4), //positive and negative line
     .rneg(rxdn4),
     .rclk(rxclk4),

     //to LIU
     .tpos(txdp4),
     .tneg(txdn4),

     //framer
     .serin(serout4), //serial //fromframer
     .serout(serin4), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do4;
wire           vld4;
wire [WID-1:0] di4;
wire           endi4;

e1frwrapped #(WID) e1frwrapped4i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin4), // from HDB3
     .serout(serout4),//to hdb3

     .rclk(rxclk4), //from rx LIU
     
     //to data mux
     .dataout(do4),
     .dovld(vld4),//@clk19

     //from VC VT
     .datain(di4),
     .endi19(endi4),//@clk19

     //from LIU
     .los(los4),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin5;
wire   serout5;

hdb3wrapped hdb3wrapped5i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp5), //positive and negative line
     .rneg(rxdn5),
     .rclk(rxclk5),

     //to LIU
     .tpos(txdp5),
     .tneg(txdn5),

     //framer
     .serin(serout5), //serial //fromframer
     .serout(serin5), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do5;
wire           vld5;
wire [WID-1:0] di5;
wire           endi5;

e1frwrapped #(WID) e1frwrapped5i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin5), // from HDB3
     .serout(serout5),//to hdb3

     .rclk(rxclk5), //from rx LIU
     
     //to data mux
     .dataout(do5),
     .dovld(vld5),//@clk19

     //from VC VT
     .datain(di5),
     .endi19(endi5),//@clk19

     //from LIU
     .los(los5),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin6;
wire   serout6;

hdb3wrapped hdb3wrapped6i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp6), //positive and negative line
     .rneg(rxdn6),
     .rclk(rxclk6),

     //to LIU
     .tpos(txdp6),
     .tneg(txdn6),

     //framer
     .serin(serout6), //serial //fromframer
     .serout(serin6), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do6;
wire           vld6;
wire [WID-1:0] di6;
wire           endi6;

e1frwrapped #(WID) e1frwrapped6i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin6), // from HDB3
     .serout(serout6),//to hdb3

     .rclk(rxclk6), //from rx LIU
     
     //to data mux
     .dataout(do6),
     .dovld(vld6),//@clk19

     //from VC VT
     .datain(di6),
     .endi19(endi6),//@clk19

     //from LIU
     .los(los6),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin7;
wire   serout7;

hdb3wrapped hdb3wrapped7i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp7), //positive and negative line
     .rneg(rxdn7),
     .rclk(rxclk7),

     //to LIU
     .tpos(txdp7),
     .tneg(txdn7),

     //framer
     .serin(serout7), //serial //fromframer
     .serout(serin7), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do7;
wire           vld7;
wire [WID-1:0] di7;
wire           endi7;

e1frwrapped #(WID) e1frwrapped7i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin7), // from HDB3
     .serout(serout7),//to hdb3

     .rclk(rxclk7), //from rx LIU
     
     //to data mux
     .dataout(do7),
     .dovld(vld7),//@clk19

     //from VC VT
     .datain(di7),
     .endi19(endi7),//@clk19

     //from LIU
     .los(los7),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin8;
wire   serout8;

hdb3wrapped hdb3wrapped8i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp8), //positive and negative line
     .rneg(rxdn8),
     .rclk(rxclk8),

     //to LIU
     .tpos(txdp8),
     .tneg(txdn8),

     //framer
     .serin(serout8), //serial //fromframer
     .serout(serin8), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do8;
wire           vld8;
wire [WID-1:0] di8;
wire           endi8;

e1frwrapped #(WID) e1frwrapped8i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin8), // from HDB3
     .serout(serout8),//to hdb3

     .rclk(rxclk8), //from rx LIU
     
     //to data mux
     .dataout(do8),
     .dovld(vld8),//@clk19

     //from VC VT
     .datain(di8),
     .endi19(endi8),//@clk19

     //from LIU
     .los(los8),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin9;
wire   serout9;

hdb3wrapped hdb3wrapped9i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp9), //positive and negative line
     .rneg(rxdn9),
     .rclk(rxclk9),

     //to LIU
     .tpos(txdp9),
     .tneg(txdn9),

     //framer
     .serin(serout9), //serial //fromframer
     .serout(serin9), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do9;
wire           vld9;
wire [WID-1:0] di9;
wire           endi9;

e1frwrapped #(WID) e1frwrapped9i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin9), // from HDB3
     .serout(serout9),//to hdb3

     .rclk(rxclk9), //from rx LIU
     
     //to data mux
     .dataout(do9),
     .dovld(vld9),//@clk19

     //from VC VT
     .datain(di9),
     .endi19(endi9),//@clk19

     //from LIU
     .los(los9),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin10;
wire   serout10;

hdb3wrapped hdb3wrapped10i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp10), //positive and negative line
     .rneg(rxdn10),
     .rclk(rxclk10),

     //to LIU
     .tpos(txdp10),
     .tneg(txdn10),

     //framer
     .serin(serout10), //serial //fromframer
     .serout(serin10), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do10;
wire           vld10;
wire [WID-1:0] di10;
wire           endi10;

e1frwrapped #(WID) e1frwrapped10i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin10), // from HDB3
     .serout(serout10),//to hdb3

     .rclk(rxclk10), //from rx LIU
     
     //to data mux
     .dataout(do10),
     .dovld(vld10),//@clk19

     //from VC VT
     .datain(di10),
     .endi19(endi10),//@clk19

     //from LIU
     .los(los10),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin11;
wire   serout11;

hdb3wrapped hdb3wrapped11i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp11), //positive and negative line
     .rneg(rxdn11),
     .rclk(rxclk11),

     //to LIU
     .tpos(txdp11),
     .tneg(txdn11),

     //framer
     .serin(serout11), //serial //fromframer
     .serout(serin11), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do11;
wire           vld11;
wire [WID-1:0] di11;
wire           endi11;

e1frwrapped #(WID) e1frwrapped11i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin11), // from HDB3
     .serout(serout11),//to hdb3

     .rclk(rxclk11), //from rx LIU
     
     //to data mux
     .dataout(do11),
     .dovld(vld11),//@clk19

     //from VC VT
     .datain(di11),
     .endi19(endi11),//@clk19

     //from LIU
     .los(los11),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin12;
wire   serout12;

hdb3wrapped hdb3wrapped12i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp12), //positive and negative line
     .rneg(rxdn12),
     .rclk(rxclk12),

     //to LIU
     .tpos(txdp12),
     .tneg(txdn12),

     //framer
     .serin(serout12), //serial //fromframer
     .serout(serin12), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do12;
wire           vld12;
wire [WID-1:0] di12;
wire           endi12;

e1frwrapped #(WID) e1frwrapped12i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin12), // from HDB3
     .serout(serout12),//to hdb3

     .rclk(rxclk12), //from rx LIU
     
     //to data mux
     .dataout(do12),
     .dovld(vld12),//@clk19

     //from VC VT
     .datain(di12),
     .endi19(endi12),//@clk19

     //from LIU
     .los(los12),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin13;
wire   serout13;

hdb3wrapped hdb3wrapped13i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp13), //positive and negative line
     .rneg(rxdn13),
     .rclk(rxclk13),

     //to LIU
     .tpos(txdp13),
     .tneg(txdn13),

     //framer
     .serin(serout13), //serial //fromframer
     .serout(serin13), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do13;
wire           vld13;
wire [WID-1:0] di13;
wire           endi13;

e1frwrapped #(WID) e1frwrapped13i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin13), // from HDB3
     .serout(serout13),//to hdb3

     .rclk(rxclk13), //from rx LIU
     
     //to data mux
     .dataout(do13),
     .dovld(vld13),//@clk19

     //from VC VT
     .datain(di13),
     .endi19(endi13),//@clk19

     //from LIU
     .los(los13),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin14;
wire   serout14;

hdb3wrapped hdb3wrapped14i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp14), //positive and negative line
     .rneg(rxdn14),
     .rclk(rxclk14),

     //to LIU
     .tpos(txdp14),
     .tneg(txdn14),

     //framer
     .serin(serout14), //serial //fromframer
     .serout(serin14), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do14;
wire           vld14;
wire [WID-1:0] di14;
wire           endi14;

e1frwrapped #(WID) e1frwrapped14i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin14), // from HDB3
     .serout(serout14),//to hdb3

     .rclk(rxclk14), //from rx LIU
     
     //to data mux
     .dataout(do14),
     .dovld(vld14),//@clk19

     //from VC VT
     .datain(di14),
     .endi19(endi14),//@clk19

     //from LIU
     .los(los14),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin15;
wire   serout15;

hdb3wrapped hdb3wrapped15i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp15), //positive and negative line
     .rneg(rxdn15),
     .rclk(rxclk15),

     //to LIU
     .tpos(txdp15),
     .tneg(txdn15),

     //framer
     .serin(serout15), //serial //fromframer
     .serout(serin15), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do15;
wire           vld15;
wire [WID-1:0] di15;
wire           endi15;

e1frwrapped #(WID) e1frwrapped15i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin15), // from HDB3
     .serout(serout15),//to hdb3

     .rclk(rxclk15), //from rx LIU
     
     //to data mux
     .dataout(do15),
     .dovld(vld15),//@clk19

     //from VC VT
     .datain(di15),
     .endi19(endi15),//@clk19

     //from LIU
     .los(los15),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin16;
wire   serout16;

hdb3wrapped hdb3wrapped16i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp16), //positive and negative line
     .rneg(rxdn16),
     .rclk(rxclk16),

     //to LIU
     .tpos(txdp16),
     .tneg(txdn16),

     //framer
     .serin(serout16), //serial //fromframer
     .serout(serin16), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do16;
wire           vld16;
wire [WID-1:0] di16;
wire           endi16;

e1frwrapped #(WID) e1frwrapped16i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin16), // from HDB3
     .serout(serout16),//to hdb3

     .rclk(rxclk16), //from rx LIU
     
     //to data mux
     .dataout(do16),
     .dovld(vld16),//@clk19

     //from VC VT
     .datain(di16),
     .endi19(endi16),//@clk19

     //from LIU
     .los(los16),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin17;
wire   serout17;

hdb3wrapped hdb3wrapped17i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp17), //positive and negative line
     .rneg(rxdn17),
     .rclk(rxclk17),

     //to LIU
     .tpos(txdp17),
     .tneg(txdn17),

     //framer
     .serin(serout17), //serial //fromframer
     .serout(serin17), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do17;
wire           vld17;
wire [WID-1:0] di17;
wire           endi17;

e1frwrapped #(WID) e1frwrapped17i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin17), // from HDB3
     .serout(serout17),//to hdb3

     .rclk(rxclk17), //from rx LIU
     
     //to data mux
     .dataout(do17),
     .dovld(vld17),//@clk19

     //from VC VT
     .datain(di17),
     .endi19(endi17),//@clk19

     //from LIU
     .los(los17),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin18;
wire   serout18;

hdb3wrapped hdb3wrapped18i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp18), //positive and negative line
     .rneg(rxdn18),
     .rclk(rxclk18),

     //to LIU
     .tpos(txdp18),
     .tneg(txdn18),

     //framer
     .serin(serout18), //serial //fromframer
     .serout(serin18), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do18;
wire           vld18;
wire [WID-1:0] di18;
wire           endi18;

e1frwrapped #(WID) e1frwrapped18i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin18), // from HDB3
     .serout(serout18),//to hdb3

     .rclk(rxclk18), //from rx LIU
     
     //to data mux
     .dataout(do18),
     .dovld(vld18),//@clk19

     //from VC VT
     .datain(di18),
     .endi19(endi18),//@clk19

     //from LIU
     .los(los18),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin19;
wire   serout19;

hdb3wrapped hdb3wrapped19i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp19), //positive and negative line
     .rneg(rxdn19),
     .rclk(rxclk19),

     //to LIU
     .tpos(txdp19),
     .tneg(txdn19),

     //framer
     .serin(serout19), //serial //fromframer
     .serout(serin19), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do19;
wire           vld19;
wire [WID-1:0] di19;
wire           endi19;

e1frwrapped #(WID) e1frwrapped19i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin19), // from HDB3
     .serout(serout19),//to hdb3

     .rclk(rxclk19), //from rx LIU
     
     //to data mux
     .dataout(do19),
     .dovld(vld19),//@clk19

     //from VC VT
     .datain(di19),
     .endi19(endi19),//@clk19

     //from LIU
     .los(los19),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin20;
wire   serout20;

hdb3wrapped hdb3wrapped20i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp20), //positive and negative line
     .rneg(rxdn20),
     .rclk(rxclk20),

     //to LIU
     .tpos(txdp20),
     .tneg(txdn20),

     //framer
     .serin(serout20), //serial //fromframer
     .serout(serin20), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do20;
wire           vld20;
wire [WID-1:0] di20;
wire           endi20;

e1frwrapped #(WID) e1frwrapped20i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin20), // from HDB3
     .serout(serout20),//to hdb3

     .rclk(rxclk20), //from rx LIU
     
     //to data mux
     .dataout(do20),
     .dovld(vld20),//@clk19

     //from VC VT
     .datain(di20),
     .endi19(endi20),//@clk19

     //from LIU
     .los(los20),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

wire   serin21;
wire   serout21;

hdb3wrapped hdb3wrapped21i
    (
     .clk2(clk2),
     .rst(rst),

     //from LIU
     .rpos(rxdp21), //positive and negative line
     .rneg(rxdn21),
     .rclk(rxclk21),

     //to LIU
     .tpos(txdp21),
     .tneg(txdn21),

     //framer
     .serin(serout21), //serial //fromframer
     .serout(serin21), //to framer

     //NRZ
     .nrzrx(1'b0), //1 to enable 0 to disable @clk2
     .nrztx(1'b0)
     );

wire [WID-1:0] do21;
wire           vld21;
wire [WID-1:0] di21;
wire           endi21;

e1frwrapped #(WID) e1frwrapped21i
    (
     .clk2(clk2),
     .clk19(clk19),
     .rst(rst),

     .serin(serin21), // from HDB3
     .serout(serout21),//to hdb3

     .rclk(rxclk21), //from rx LIU
     
     //to data mux
     .dataout(do21),
     .dovld(vld21),//@clk19

     //from VC VT
     .datain(di21),
     .endi19(endi21),//@clk19

     //from LIU
     .los(los21),//@clk2

     //crc monitor
     .rxcrcerr(),
     .rxcrcmfa()
     );

e1datamux #(WID) e1datamuxi
    (
     .clk(clk19), //@clk19
     .rst(rst),

     //data from 21 E1 channel
     .di1(do1),
     .di2(do2),
     .di3(do3),
     .di4(do4),
     .di5(do5),
     .di6(do6),
     .di7(do7),
     .di8(do8),
     .di9(do9),
     .di10(do10),
     .di11(do11),
     .di12(do12),
     .di13(do13),
     .di14(do14),
     .di15(do15),
     .di16(do16),
     .di17(do17),
     .di18(do18),
     .di19(do19),
     .di20(do20),
     .di21(do21),

     //vld from 21 E1 channel @clk19
     .vld1(vld1),
     .vld2(vld2),
     .vld3(vld3),
     .vld4(vld4),
     .vld5(vld5),
     .vld6(vld6),
     .vld7(vld7),
     .vld8(vld8),
     .vld9(vld9),
     .vld10(vld10),
     .vld11(vld11),
     .vld12(vld12),
     .vld13(vld13),
     .vld14(vld14),
     .vld15(vld15),
     .vld16(vld16),
     .vld17(vld17),
     .vld18(vld18),
     .vld19(vld19),
     .vld20(vld20),
     .vld21(vld21),
     
     .oid(), //chanel ID
     .do(), //data out
     .dovld() //data out valid
     
     );

////////////////////////////////////////////////////////////////////////////////
//Memory Bridge instantiation

wire [RWID-1:0] row;
wire [CWID-1:0] col;
wire [WID-1:0] dotx;

wire [WID-1:0] dirx;
wire           txsof;
wire           rxsof;

wire           tug3entx;
wire [WID-1:0] tug3di;
wire           tug3enrx;
wire [WID-1:0] tug3do;

wire           vc4entx;
wire [WID-1:0] vc4di;
wire           vc4enrx;
wire [WID-1:0] vc4do;

wire           au4entx;
wire [WID-1:0] au4di;
wire           au4enrx;
wire [WID-1:0] au4do;

wire           inc;
wire           dec;

wire           stmentx;
wire [WID-1:0] stmdi;
wire           stmenrx;
wire [WID-1:0] stmdo;


memctrlwrapped memctrlwrappedi
    (
     .clk19(clk19),
     .rst(rst),

     .row(row), //to tx p2s
     .col(col),
     .sts(),
     .dotx(dotx),

     .dirx(dirx),//from rx s2p
     .rxsof(rxsof),
     .txsof(txsof),

     .tug3entx(tug3entx),//from tx tug3
     .tug3di(tug3di),

     .tug3enrx(tug3enrx), //to rx TUG3
     .tug3do(tug3do),
     
     .vc4entx(vc4entx),//to tx vc4
     .vc4di(vc4di),

     .vc4enrx(vc4enrx), // to rx VC4
     .vc4do(vc4do),
     
     .au4entx(au4entx),//to tx au4
     .au4di(au4di),

     .au4enrx(au4enrx), // to rx AU4
     .au4do(au4do),
     
     .inc(inc),// from AU4
     .dec(dec),
     
     .stmentx(stmentx),//to tx stm
     .stmdi(stmdi),
     
     .stmenrx(stmenrx),// to rx STM
     .stmdo(stmdo)
     );

////////////////////////////////////////////////////////////////////////////////
//VT Mapper VC4 instantiation

//////////VT Mapper - TUG3

//Tx Multiframe



//////////VC4

wire [WID-1:0] bipdat;
wire           bipvld;

wire [3:0]     reidat;
wire           reivld;

//Rx VC4

vc4poh_rx vc4poh_rxi
    (
     .clk(clk19),
     .rst(rst),
     .rxsof(rxsof),
     .en(vc4enrx),
     .dpohin(vc4do),
     
     .tug3bip8(bipdat),
     .bip_vld(bipvld),
     
     .rei_bip8(reidat),
     .rei_vld(reivld)

     );

//Tx VC4

vc4poh_tx vc4poh_txi
    (
     .clk(clk19),
     .rst(rst),
     
     .dinbip8(bipdat),
     .bip_vld(bipvld),
     
     .rei_bip8(reidat),
     .rei_vld(reivld),
 
     .en(vc4entx),
     .dpoh(vc4di),

     .txsof(txsof)
     );

////////////////////////////////////////////////////////////////////////////////
//STM/AU4 logic instantiation

//AU4 Rx

ptrmon ptrmoni
    (
     .clk19(clk19),
     .rst(rst),

     .din(au4do),
     .en(au4enrx),
     .rxsof(rxsof),

     .dout(),
     .vld(),
     .inc(inc),
     .dec(dec),
     .lop(),
     .ais()
     );

//AU4 Tx

ptrgen  ptrgeni
    (
     .clk19(clk19),
     .rst(rst),

     .wdat(au4di),
     .en(au4entx),
     .txsof(txsof)
     );

//Rx stm

wire [23:0]    b2datrx;
wire           b2vldrx;

wire [WID-1:0] m1dat;

rxframer rxframeri
    (
     .clk19(clk19),
     .rst(rst),

     .rdat(stmdo),
     .en(stmenrx),
     .rxsof(rxsof),
     .b2dat(b2datrx),
     .b2vld(b2vldrx),

     .m1dat(m1dat)
     );

stm1s2p_wrapped stm1s2pi
    (
     .clk155(clk155),
     .rst155(rst),

     .clk19(clk19),
     .rst19(rst),
     
     .sdi(rxstm1), // input stm1

     .pdo(dirx),
     .sof(rxsof),
     .b2dat(b2datrx),
     .b2vld(b2vldrx)
     );

//Tx stm

wire [23:0]    b2dattx;
wire           b2vldtx;
wire [7:0]     b1dattx;
wire           b1vldtx;

txframer txframeri
    (
     .clk19(clk19),
     .rst(rst),

     .wdat(stmdi),
     .en(stmentx),
     .rxsof(rxsof),
     .txsof(txsof),
     
     .b2dat(b2dattx),
     .b2vld(b2vldtx),
     .m1dat(m1dat),
     .b1dat(b1dattx),
     .b1vld(b1vldtx)
     );

stm1p2s_wrapped stm1p2si
    (
     .clk155(clk155),
     .rst155(rst),

     .clk19(clk19),
     .rst19(rst),
     
     .rrow(row),
     .rcol(col),
     .pdi(dotx),

     .b1dat(b1dattx),
     .b1vld(b1vldtx),
     .b2dat(b2dattx),
     .b2vld(b2vldtx),
     
     .sdo(txstm1) //output stm1
     );

endmodule