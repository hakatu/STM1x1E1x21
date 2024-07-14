// Filename     : piso.v
// Description  : Parallel in every 8 clock edges, serial out. 
////////////////////////////////////////////////////////////////////////////////

module piso
    (
     clk155,
     rst155,
     
     clk19,
     rst19,
     
     ps_rdat,
     ps_rrow,
     ps_rcol,
     
     ps_sdo,
     sce
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk155;
input   rst155;

input   clk19;
input   rst19;

input [7:0] ps_rdat;
input [3:0] ps_rrow;
input [6:0] ps_rcol;

output      ps_sdo;
output      sce; // scrambling enable

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg         sce;

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter   INIT = 0;

////////////////////////////////////////////////////////////////////////////////
// paralell to serial data
// spcecify sce and rsoh_byte signal

reg [7:0]   itmp;
reg [2:0]   cnt;

wire        soh0;
assign      soh0 = (ps_rrow == 0) && (ps_rcol < 3);


//------------------------------------------------------
reg         rd;
wire        write, read;
wire [3:0]  wraddr;
wire [3:0]  rdaddr;

convclk_grayffctrl #(4,16) convclk_grayffctrli
    (
     .wrclk(clk19),
     .rdclk(clk155),
     .wrrst(rst19),
     .rdrst(rst155),

     .fifowr(1'b1),
     .fiford(rd),
     
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

wire [7:0] do;
wire       soh;

iarray111x #(4,16,9) iarray111xi
    (
     .wrst(rst19),
     .wclk(clk19),
     .wa(wraddr),
     .we(write),
     .di({ps_rdat, soh0}),

     .rrst(rst155),
     .rclk(clk155),
     .ra(rdaddr),
     .re(read),
     .do({do, soh}),

     .test(),
     .mask()
     );

//---------------------------------------------

always @(posedge clk155)
    begin
    if (rst155)
        begin
        itmp    <= INIT;
        cnt     <= INIT;
        rd      <= INIT;
        sce     <= 1'b1;
        end
    else
        begin
        cnt     <= cnt + 3'b001;
        if (cnt == 3'b000)
            begin
            itmp    <= do;
            rd      <= 1'b1;
            // detect first soh row to not scramble
            if (soh)
                begin
                sce  <= 1'b0;
                end
            else
                begin
                sce  <= 1'b1;
                end
            end
        else
            begin
            itmp    <= itmp << 1;
            rd      <= INIT;
            end
        end
    end

assign ps_sdo = itmp[7];

















endmodule 
