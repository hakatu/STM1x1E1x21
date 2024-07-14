// Filename     : intfmux8.v
// Description  : mux 8,7,6,5,4,3,2,1 for FPGA intergration
////////////////////////////////////////////////////////////////////////////////

module intfdemux6
    (
     rst_,
     iclk38, 
     
     idat,      // data receive ~ iclk38
     isyn,      // sync strobe  ~ iclk38

     odat       // data out
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter LINEBIT = 12;      // Bit of data befor DEMUX
parameter DEMUX   = 6;      // Demux 4, 3, or 2
parameter BITTS   = 3;      // Bit of time slot counter
parameter MAXTS   = 4;      // Number of time slot synclk to hold transmit data
parameter DATABIT = DEMUX*LINEBIT;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input                rst_;
input                iclk38;

input [LINEBIT-1:0]  idat;
input                isyn;

output [DATABIT-1:0] odat;
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
/*
//detect refclk
reg [2:0]   shfdet;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) shfdet <= 3'd0;
    else      shfdet <= {shfdet[1:0],irefclk};
    end

wire    posdet;
assign  posdet = (shfdet == 3'b011);
*/
//  
reg [2:0] cntph;
wire      endcntph;
assign    endcntph = (cntph == (DEMUX-1));

always @(posedge iclk38 or negedge rst_)
    begin
    if(!rst_) cntph <= 3'd0;
    else if(isyn)       cntph <= 3'd1;
    //else if(endcntph)   cntph <= DEMUX-1;
    else                cntph <= cntph + 1'b1;
    end
       
reg [DATABIT-1:0] dashf;
wire [DATABIT+LINEBIT-1:0] dacap;
assign                     dacap = {dashf,idat};

always @(posedge iclk38 or negedge rst_)
    begin
    if(!rst_)   dashf <= {DATABIT{1'b0}};
    else        dashf <= dacap[DATABIT-1:0];
    end

//assign  odat = dacap[DATABIT-1:0];

reg [DATABIT-1:0] odat;
wire              latch_dat;
assign            latch_dat = (cntph == (DEMUX-1));
always @(posedge iclk38 or negedge rst_)
    begin
    if(!rst_) odat <= {DATABIT{1'b0}};
    else if(latch_dat) odat <= dacap[DATABIT-1:0];
    end

endmodule 
