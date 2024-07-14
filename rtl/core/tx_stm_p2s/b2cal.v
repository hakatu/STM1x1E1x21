// Filename     : b2cal.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module b2cal
    (
     clk155,
     rst,

     b2sdi,
     sof,
     b2pdo,
     b2vld
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input clk155;
input rst;

input b2sdi;
input sof;
output b2vld;
output [23:0] b2pdo;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

reg [23:0]    b2pdo;
reg           b2vld;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

reg [4:0]     ptr;
reg [23:0]    bip24;
reg [23:0]    bip24_tmp;

reg [2:0]     nxbcnt;   // next bit counter
reg [9:0]     cnt;
reg           flag; // RSOH bytes were all received
reg           stop; // stop calculating B2

////////////////////////////////////////////////////////////////////////////////
// RSOH bytes are indicated

wire          cond1, cond2;
assign        cond1 = ((cnt == 8) ||
                       (cnt == 278) ||
                       (cnt == 548)) && (nxbcnt == 3'b111);
assign        cond2 = ((cnt == 269) ||
                       (cnt == 539)) && (nxbcnt == 3'b111);

always @(posedge clk155)
    begin
    if (rst)
        begin
        cnt     <= 10'd0;
        nxbcnt  <= 3'b000;
        flag    <= 1'b0;
        stop    <= 1'b0;
        end
    else if (sof)
        begin
        cnt     <= 10'd0;
        nxbcnt  <= 3'b001;
        flag    <= 1'b0;
        stop    <= 1'b1;
        end
    else if (!flag)
        begin
        nxbcnt  <= nxbcnt + 3'd1;
        if (nxbcnt == 3'b111)
            begin
            cnt     <= cnt + 10'd1;
            end
        // control stop
        if (cond1)
            begin
            stop    <= 1'b0;
            end
        else if (cond2)
            begin
            stop    <= 1'b1;
            end
        // control flag     
        if ((cnt == 10'd548) && (nxbcnt == 3'b111))
            begin
            flag    <= 1'b1;
            end
        else
            begin
            flag    <= 1'b0;
            end
        end
    end

///////////////////////////////////////////////////////////////////////////////
// B2 calculation
        
always @(posedge clk155)
    begin
    if (rst)
        begin
        ptr         <= 5'd0;
        bip24       <= 24'd0;
        bip24_tmp   <= 24'd0;
        b2pdo       <= 24'd0;
        end
    // update new B2 at the start of frame
    else if (sof)
        begin
        ptr         <= 5'b00001;   // point to next bip24_tmp bit
        bip24_tmp   <= 24'd0;
        bip24       <= 24'd0;    
        b2pdo       <= bip24;
        end
    // cal B2 if data is not a RSOH byte
    else if (!stop) 
        begin
        if (ptr >= 5'd23)
            begin
            ptr         <= 5'd0;    // ptr backs to bit 1
            bip24[ptr]  <= bip24_tmp[ptr] ^ b2sdi;
            bip24_tmp[ptr-1]    <= bip24[ptr-1];
            end
        else if (ptr == 5'd0)
            begin
            ptr         <= ptr + 5'd1;
            bip24[ptr]  <= bip24_tmp[ptr] ^ b2sdi;
            bip24_tmp[5'd23]     <= bip24[5'd23];  
            end
        else
            begin
            ptr         <= ptr + 5'd1;
            bip24[ptr]  <= bip24_tmp[ptr] ^ b2sdi;
            bip24_tmp[ptr-1]    <= bip24[ptr-1];
            end
        end
    end

///////////////////////////////////////////////////////////////////////////////
// Control valid signal
// Valid signal is high at start of frame and lasts in 8 clocks

always @(posedge clk155)
    begin
    if (rst)
        begin
        b2vld   <= 1'b0;
        end
    else if (sof)
        begin
        b2vld   <= 1'b1;
        end
    else if (nxbcnt == 3'b111)
        begin
        b2vld   <= 1'b0;
        end
    else
        begin
        b2vld   <= b2vld;
        end
    end

endmodule
    
