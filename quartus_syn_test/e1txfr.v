// Filename     : e1txfr
// Description  : 
////////////////////////////////////////////////////////////////////////////////

module e1txfr
    (
     clk2,
     clk19,
     rst,

     //to VC VT
     datain,
     divld,
     endi, //data in enable

     //to HDB3 Encoder
     serout
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk2;
input   clk19;
input   rst;

input   [WID-1:0]   datain;
input               divld;
output              endi;

output              serout;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter WID = 8;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
//synchronize input

wire      divld1,divld2;
wire      valid;

fflopx #(1) ffvldi(clk2,rst,divld,divld1);
fflopx #(1) ffvld2i(clk2,rst,divld1,divld2);

assign    valid = divld2;

//data out shift register PISO
reg [WID-1:0] seroutrg;
wire          newdata;

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
reg         endi;
reg         ready;
reg [7:0]   count;


always@(posedge clk2)
    begin
    if(rst)
        ready <= 1'b1;
    else
        begin
        if(ready)
            begin
            endi <= 1'b1;
            ready <= valid? 1'b0 : 1'b1;
            count <= 3'b111;
            end
        else
            begin
            endi      <=  1'b0;
            count   <=  count - 3'b1;
            if(count == 3'b000)
                ready <= 1'b1;
            end
        end
    end

////////////////////////////////////////////////////////////////////////////////

endmodule 
