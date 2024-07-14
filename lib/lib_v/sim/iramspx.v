// Filename        : iramspx.v
// Description     : a library of single port RAM model
//////////////////////////////////////////////////////////////////////////////////

module iramspx
    (
     clk,
     a,
     we,
     re,
     di,
     do,
     
     test,
     mask
     );

parameter ADDRBIT = 11;
parameter DEPTH = 1536;
parameter WIDTH = 32;
parameter TYPE  = "AUTO";
parameter MAXDEPTH = 0;
parameter DISPLAY_ERR_RAM_RD    = "ON";

input               clk;
input [ADDRBIT-1:0] a;
input               we;
input [WIDTH-1:0]   di;
input               re;
output [WIDTH-1:0]  do;
input               mask;   // =1, re is disable
input               test;   // rd and wr are disable

reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [WIDTH-1:0] do;

integer i;
initial
    begin 
    for(i=0;i<DEPTH;i=i+1)
        ram[i] = {WIDTH{1'b0}};
    end

always @ (posedge clk)
    begin
    if (we & (!test))
        begin
        ram[a] <= di;
        //do <= {WIDTH{1'bx}};  do not like altera model.
        end

    if (test) do <= {WIDTH{1'b0}};
    else if (re | mask)
        begin
        if (!we)    do <= ram[a];
        else
            begin
            do <= {WIDTH{1'bx}};

            `ifdef DISPLAY_ERR_RAM_RD_OFF
            `else
            if (DISPLAY_ERR_RAM_RD == "ON")
                $display("ERR_RAM: RD and WR at the same time at %h %t %m",a,$time);
            `endif
          
            end
        end
    else    do  <= {WIDTH{1'bx}};
    end

// for debug
wire    sameaddr;
assign sameaddr = we & re;

endmodule

