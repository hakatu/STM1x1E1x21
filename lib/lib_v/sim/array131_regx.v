// Filename     : array131_regx.v
// Description  : .
////////////////////////////////////////////////////////////////////////////////

module array131_regx (rst_,wclk,wa,we,di,
                      rclk1,ra1,do1,
                      rclk2,ra2,do2,
                      rclk3,ra3,do3);

parameter ADDRBIT = 9;
parameter DEPTH = 512;
parameter WIDTH = 32;
parameter TYPE = "AUTO";
parameter MAXDEPTH = 0;

input               rst_;
input               wclk;
input [ADDRBIT-1:0] wa;
input               we;
input [WIDTH-1:0]   di;
input               rclk1;
input [ADDRBIT-1:0] ra1;
output [WIDTH-1:0]  do1;
input               rclk2;
input [ADDRBIT-1:0] ra2;
output [WIDTH-1:0]  do2;
input               rclk3;
input [ADDRBIT-1:0] ra3;
output [WIDTH-1:0]  do3;


////////////////////////////////////////////////////////////////////////////////
reg [WIDTH-1:0]     do1, do2, do3;
reg [WIDTH-1:0]     reg_array [DEPTH-1:0];

integer i;

always @ (posedge wclk or negedge rst_)
    begin
    if (~rst_)
        begin
        for (i = 0; i < DEPTH; i = i + 1)
            begin
            reg_array[i] <= {WIDTH{1'b0}};
            end
        end
    else if (we)
        begin
        reg_array[wa] <= di;
        end
    end

always @ (posedge rclk1 or negedge rst_)
    begin
    if (~rst_)
        begin
        do1 <= {WIDTH{1'b0}};
        end
    else
        begin
        do1 <= reg_array[ra1];
        end
    end

always @ (posedge rclk2 or negedge rst_)
    begin
    if (~rst_)
        begin
        do2 <= {WIDTH{1'b0}};
        end
    else
        begin
        do2 <= reg_array[ra2];
        end
    end

always @ (posedge rclk3 or negedge rst_)
    begin
    if (~rst_)
        begin
        do3 <= {WIDTH{1'b0}};
        end
    else
        begin
        do3 <= reg_array[ra3];
        end
    end

endmodule