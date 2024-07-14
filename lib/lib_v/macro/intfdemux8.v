// Filename     : intfdemux8.v
// Description  : demux 8,7,6,5,4,3,2,1 for FPGA intergration
////////////////////////////////////////////////////////////////////////////////

module intfdemux8
    (
     rst_,
     synclk,    // high clock for capturing data (155.52Mhz)
     
     idat,      // data receive
     isyn,      // sync strobe
   
     odat       // data out
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

parameter LINEBIT = 1;      // Bit of data befor DEMUX
parameter DEMUX   = 4;      // Demux 4, 3, or 2
parameter BITTS   = 3;      // Bit of time slot counter
parameter MAXTS   = 6;      // Number of time slot synclk to hold transmit data
parameter DATABIT = DEMUX*LINEBIT;

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input                rst_;
input [LINEBIT-1:0]  idat;
input                isyn;

input                synclk;
output [DATABIT-1:0] odat;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [2:0]   shfdet;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) shfdet <= 3'd0;
    else      shfdet <= {shfdet[1:0],isyn};
    end

wire    posdet;
assign  posdet = shfdet == 3'b011;

reg [MAXTS-5:0] posdetpipe;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) posdetpipe <= {(MAXTS-4){1'b0}};
    else      posdetpipe <= {posdetpipe[MAXTS-6:0],posdet};
    end

wire    capture;
assign  capture = posdetpipe[MAXTS-5];

reg [BITTS-1:0] cntts;
wire            endcntts;
assign          endcntts = cntts == (MAXTS-1);

always @(posedge synclk or negedge rst_)
    begin
    if(!rst_)         cntts <= {BITTS{1'b0}};
    else if(capture)  cntts <= {BITTS{1'b0}};
    else if(endcntts) cntts <= {BITTS{1'b0}};
    else              cntts <= cntts + 1'b1;
    end
    
reg [2:0] cntph;
wire      endcntph;
assign    endcntph = cntph == (DEMUX-1);

always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) cntph <= 3'd0;
    else if(capture)  cntph <= 3'd0;
    else if(endcntph) cntph <= DEMUX-1;
    else if(endcntts) cntph <= cntph + 1'b1;
    end

wire    shiften;
//assign  shiften = capture | ((cntph < (DEMUX-2)) & endcntts);
assign  shiften = capture | ((cntph < (DEMUX-1)) & endcntts);

reg [DATABIT-1:0] dashf;
wire [DATABIT+LINEBIT-1:0] dacap;
assign                     dacap = {dashf,idat};

always @(posedge synclk or negedge rst_)
    begin
    if(!rst_)        dashf <= {DATABIT{1'b0}};
    else if(shiften) dashf <= dacap[DATABIT-1:0];
    end

//assign  odat = dacap[DATABIT-1:0];

reg [DATABIT-1:0] odat;
always @(posedge synclk or negedge rst_)
    begin
    if(!rst_) odat <= {DATABIT{1'b0}};
    else if(endcntts & (cntph == (DEMUX-2))) odat <= dacap[DATABIT-1:0];
    end

endmodule 
