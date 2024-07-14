module mem_1 (clk, addr, wr_ena, data);
parameter DATA_WIDTH = 8;
input clk;
input [10:0] addr;
input wr_ena;
output [DATA_WIDTH-1:0] data;
reg [DATA_WIDTH-1:0] data;
always@(posedge clk) begin
 case (addr)
     0 : data <= 8'b01010101;
     1 : data <= 8'b01100011;
     2 : data <= 8'b01111111;
     3 : data <= 8'b01110110;
    default : data <= 0;
    endcase
end
endmodule
