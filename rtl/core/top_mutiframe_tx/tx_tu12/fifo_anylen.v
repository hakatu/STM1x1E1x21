// Filename     : fifo_anylen.v
// Description  : This control fifo supports any length of fifo.
////////////////////////////////////////////////////////////////////////////////

module fifo_anylen
    (
     clk,
     rst_,

     // FIFO control
     fifowr,
     fiford,
     fifofsh,

     notempty,
     full,
     fifolen,
     di,
     do

    );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter LENGTH = 16;
parameter ADDRBIT = 4;
parameter WIDTH = 8;


////////////////////////////////////////////////////////////////////////////////
// Port declarations
input clk;
input rst_;
input [WIDTH-1:0] di;

// FIFO control
input             fifowr;
input             fiford;
input             fifofsh;

output            notempty;
output            full;
output [ADDRBIT:0] fifolen;
output [WIDTH-1:0] do;
////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [WIDTH-1:0]      memfifo [LENGTH-1:0];
reg [WIDTH-1:0]      do;
////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
reg [ADDRBIT:0] fifolen;
reg [ADDRBIT:0] rdcnt;

wire [ADDRBIT:0] sumcnt;
assign           sumcnt = rdcnt + fifolen;
wire [ADDRBIT:0] over;
assign           over = sumcnt - LENGTH;
wire [ADDRBIT:0] wrcnt;
assign           wrcnt = (sumcnt < LENGTH) ? sumcnt[ADDRBIT:0] : over[ADDRBIT:0];

wire    notempty;
assign  notempty = |fifolen;

//wire [ADDRBIT:0] checklen;
//assign           checklen = LENGTH - fifolen;
wire    checklen;
assign  checklen = fifolen == LENGTH;

wire    read;
assign  read = notempty & fiford;

wire    write;
assign  write = fifowr & (~full);

wire    full;
//assign  full = fifolen[ADDRBIT] | checklen[ADDRBIT];
assign  full = checklen;

wire [ADDRBIT:0] rdcntmax;
assign             rdcntmax = LENGTH - 1;

wire    rdcntcry;
assign  rdcntcry = rdcnt == rdcntmax;

always @(posedge clk or negedge rst_)
    begin
    if (!rst_) rdcnt <= {1'b0,{ADDRBIT{1'b0}}};
    else if (fifofsh) rdcnt <= {1'b0,{ADDRBIT{1'b0}}};  
    else if (read) rdcnt <= rdcntcry ? {1'b0,{ADDRBIT{1'b0}}} : rdcnt + 1'b1;
    end

always @(posedge clk or negedge rst_)
    begin
    if (!rst_) fifolen <= {1'b0,{ADDRBIT{1'b0}}};
    else if (fifofsh) fifolen <= {1'b0,{ADDRBIT{1'b0}}};
    else 
        begin
        case ({read,write})
            2'b01: fifolen <= fifolen + 1'b1;
            2'b10: fifolen <= fifolen - 1'b1;
            default: fifolen <= fifolen;
        endcase
        end
     end
     
integer i;
always @(posedge clk)
     begin
     if(!rst_) for(i=0;i< LENGTH; i=i+1) memfifo[i] <= {WIDTH{1'b0}};
     else if(write) memfifo[wrcnt] <= di;
     end

always @(posedge clk)
    begin
    if(!rst_) do <= {WIDTH{1'b0}};
    else if(read) do <= memfifo[rdcnt];
    else do <= {WIDTH{1'b0}};
    end


// For Test Only
/*
reg [ADDRBIT:0]    lengmax;
always @(posedge clk or negedge rst_)
    begin
    if (!rst_) lengmax <= 0;
    else if (fifolen > lengmax) lengmax <= fifolen;
    end

reg [ADDRBIT:0]    entrycount;
always @(posedge clk or negedge rst_)
    begin
    if (!rst_) entrycount <= 0;
    else if (testtop.sync) entrycount <= 0;
    else if (write) entrycount <= entrycount + 1'b1;
    end
*/
endmodule 
