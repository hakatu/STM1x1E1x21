// Filename     : rxframer.v
// Description  : Rx Framer, adding RSOH and MSOH to STM-1 frame
////////////////////////////////////////////////////////////////////////////////

module rxframer
    (
     clk19,
     rst,

     rdat,
     en,
     rxsof,
     b2dat,
     b2vld,

     m1dat
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk19;
input rst;

input [7:0] rdat;
input       en;
input       rxsof;
input [23:0] b2dat;
input        b2vld;

output [7:0] m1dat;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [7:0]    m1dat;

////////////////////////////////////////////////////////////////////////////////
// parameter declarations

parameter    INIT = 0;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

// cal write address

reg [6:0]    wa;
always @(posedge clk19)
    begin
    if(rst || rxsof)
        begin
        wa  <= INIT;
        end
    else if (en)
        begin
        wa  <= wa + 7'd1;
        end
    end

// RAM

wire [7:0]   do;
wire         re;
wire [6:0]   ra;

fflopx #(7) fflopxi (clk19, rst, wa, ra);

iarray111x  #(7, 128, 8)    mem
    (
     .wrst(rst),
     .wclk(clk19),
     .wa(wa),
     .we(en),
     .di(rdat),

     .rrst(rst),
     .rclk(clk19),
     .ra(ra),
     .re(1'b1),
     .do(do),

     .test(1'b0),
     .mask(1'b0)
     );

// receive B2 from b2cal

reg [23:0]   b2cal; 

always @(posedge clk19)
    begin
    if (rst)
        begin
        b2cal   <= INIT;
        end
    else if (b2vld)
        begin
        b2cal   <= b2dat;
        end
    end


// read new frame's B2 from memory

reg [23:0]   b2reg;

always @(posedge clk19)
    begin
    if (rst)
        begin
        b2reg   <= INIT;
        end
    else
        begin
        b2reg   <= (ra == 7'd22)? {b2reg, do} :
                   (ra == 7'd23)? {b2reg, do} : 
                   (ra == 7'd24)? {b2reg, do} : b2reg;
        end
    end


// compare B2

reg [23:0]   cmpr;

always @(posedge clk19)
    begin
    if (rst | rxsof)
        begin
        m1dat   <= INIT;
        cmpr    <= INIT;
        end
    else if (ra == 7'd25)
        begin
        cmpr    <= b2reg ^ b2cal;
        end
    else
        begin
        cmpr    <= cmpr << 1;
        m1dat   <= m1dat + cmpr[23];
        end
    end

endmodule 
