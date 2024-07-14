// Filename     : sipo.v
// Description  : Serial in parallel out
////////////////////////////////////////////////////////////////////////////////

module sipo
    (
     clk155,
     rst155,

     clk19,
     rst19,
     
     sdi,
     sof155,
     pdo,
     sof19
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk155;
input rst155;

input clk19;
input rst19;

input sdi;
input sof155;
output [7:0] pdo;
output       sof19;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter    INIT = 0;

////////////////////////////////////////////////////////////////////////////////
// Serial in parallel out 
reg [7:0]    pdat;
reg [7:0]    shfreg;
reg [2:0]    cnt;   // the number of bits was received

always @(posedge clk155)
    begin
    if (rst155)
        begin
        pdat <= INIT;
        shfreg  <= INIT;
        cnt     <= INIT;
        end
    else if (sof155) 
        begin
        cnt <= INIT;
        shfreg  <= {shfreg[6:0], sdi};
        pdat <= shfreg;
        end
    else
        begin
        cnt <= cnt + 3'b001;
        shfreg  <= {shfreg[6:0], sdi};
        if (cnt == 3'b111)
            begin
            pdat <= shfreg;
            end
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Write enable

reg [5:0]    drop;
reg wr;
always @(posedge clk155)
    begin
    if (rst155)
        begin
        drop    <= INIT;
        wr      <= INIT;
        end
    else if (sof155)
        begin
        drop    <= INIT;
        wr      <= INIT;
        end
    else
        begin
        if (drop < 6'd47)
            begin
            drop    <= drop + 1;
            wr      <= INIT;
            end
        else if (cnt == 3'b111)
            begin
            drop    <= drop;
            wr      <= 1'b1;
            end
        else
            begin
            drop    <= drop;
            wr      <= INIT;
            end
        end
    end

////////////////////////////////////////////////////////////////////////////////
// Send sof19 after received sof155 8 clocks ago

reg sofreg;
reg sof_tmp;

always @(posedge clk155)
    begin
    if (rst155)
        begin
        sofreg  <= 1'b0;
        sof_tmp <= 1'b0;
        end
    else if (sof155 || (cnt ==3'b111))
        begin
        sofreg  <= sof155;  
        sof_tmp <= sofreg;  // send out if 1 byte received
        end
    end

//------------------------------------------------------
wire        write, read;
wire [3:0]  wraddr;
wire [3:0]  rdaddr;

convclk_grayffctrl #(4,16) convclk_grayffctrli
    (
     .wrclk(clk19),
     .rdclk(clk155),
     .wrrst(rst19),
     .rdrst(rst155),

     .fifowr(wr),
     .fiford(1'b1),
     
     .fifoflush(),
     .oflushrd(),
     .oflushwr(),
     
     .fifofull(),
     .half_full(),
     .fifonemp(),

     .rdfifolen(),
     .wrfifolen(),
     
     .write(write),
     .wraddr(wraddr),
     .read(read),
     .rdaddr(rdaddr)     
     );

iarray111x #(4,16,9) iarray111xi
    (
     .wrst(rst19),
     .wclk(clk19),
     .wa(wraddr),
     .we(write),
     .di({pdat, sof_tmp}),

     .rrst(rst155),
     .rclk(clk155),
     .ra(rdaddr),
     .re(read),
     .do({pdo, sof19}),

     .test(),
     .mask()
     );

endmodule 
