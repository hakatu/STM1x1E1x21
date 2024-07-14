// Filename     : e1txfr
// Description  : Transmit Framer use Async Fast clk to slow clk PISO method
////////////////////////////////////////////////////////////////////////////////

module e1txfr
    (
     clk2,
     clk19,
     rst,

     //to VC VT
     datain,
     endi19, //data in enable pos edge sync

     //to HDB3 Encoder
     serout
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter WID = 8;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   clk19;
input   rst;

input   [WID-1:0]   datain;
output              endi19;

output              serout;

////////////////////////////////////////////////////////////////////////////////
// Output declarations


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
//data out shift register PISO
reg [WID-1:0] seroutrg;
wire          newdata;
reg           endi;

always@(posedge clk2)
    begin
    if(rst)
        seroutrg <= 8'b0;
    else if(endi)
        seroutrg <= datain;
    else
        seroutrg <= {seroutrg[6:0],1'b0};       
    end

assign serout = seroutrg[7];
                      
//state machine
reg         ready;
reg [2:0]   count;


always@(posedge clk2)
    begin
    if(rst)
        ready <= 1'b1;
    else
        begin
        if(ready)
            begin
            endi    <=  1'b1;
            ready   <=  1'b0;
            count   <=  3'b000;
            end
        else
            begin
            endi    <=  1'b0;
            count   <=  count + 3'b001;
            if(count == 3'b110)
                ready <= 1'b1;
            end
        end
    end

//endi is enable then data is latched in the next clock
// sync endi as posedge to clk 19mhz
wire meta,endi2,endi3;

fflopx #(1) ffmetai(clk19, rst, endi, meta);
fflopx #(1) ffen2i(clk19, rst, meta, endi2);
fflopx #(1) ffen3i(clk19, rst, endi2, endi3);

assign endi19 = !endi3 & endi2;

////////////////////////////////////////////////////////////////////////////////

endmodule 
