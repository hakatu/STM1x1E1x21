// Filename     : b1cal.v
// Description  : calculating byte B1 (BIP-8)
////////////////////////////////////////////////////////////////////////////////

module b1cal
    (
     clk155,
     rst,
     
     sof,  
     b1sdi,
     b1pdo,
     b1vld
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk155;
input   rst;

input   sof;
input   b1sdi;
output  b1vld;
output [7:0] b1pdo;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [2:0] ptr;
reg [7:0] bip8_tmp;
reg [7:0] bip8;

reg [7:0] b1pdo;
reg       b1vld;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

always @(posedge clk155)
    begin
    if (rst)
        begin
        bip8_tmp    <= 8'h00;
        ptr         <= 3'b000;
        bip8        <= 8'h00; 
        b1pdo       <= 8'h00;
        end
    else if (sof)
        begin
        bip8_tmp    <= 8'h00;
        ptr         <= 3'b001;   // point to next bit8_tmp bit
        bip8[0]     <= b1sdi;    
        b1pdo       <= bip8;    // update new B1 at the start of new frame
        end
    else
        begin
        ptr         <= ptr + 3'b001;
        bip8[ptr]   <= bip8_tmp[ptr] ^ b1sdi;
        bip8_tmp[ptr-1] <= bip8[ptr-1];
        end
    end

///////////////////////////////////////////////////////////////////////////////
// Control valid signal
// Valid signal is high at start of frame and lasts in 8 clocks

always @(posedge clk155)
    begin
    if (rst)
        begin
        b1vld   <= 1'b0;
        end
    else if (sof)
        begin
        b1vld   <= 1'b1;
        end
    else if (ptr == 3'b111)
        begin
        b1vld   <= 1'b0;
        end
    else
        begin
        b1vld   <= b1vld;
        end
    end

endmodule 
