// Filename     : hdb3ec.v
// Description  : hdb3 encoder with pos, neg and zero when pos and neg is zero
////////////////////////////////////////////////////////////////////////////////

module amihdb3ec
    (
     clk,
     rst,

     ipos, //ami data in
     ineg,
     
     opos,//signal out
     oneg
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input   clk;
input   rst;

input   ipos;
input   ineg;

output  opos;
output  oneg;

////////////////////////////////////////////////////////////////////////////////
// Signal declarations

////////////////////////////////////////////////////////////////////////////////
//Insert balance and violation
wire    [1:0]   inami;

assign  inami  = {ipos,ineg};

wire    polar, nxtpolar;

fflopx #(1) ffpolari(clk,rst,nxtpolar,polar);

assign nxtpolar = (inami == 2'b10)? 1'b1 : (inami == 2'b01)? 1'b0 : polar;

wire   odd, nxtodd;

fflopx #(1) ffoddi(clk,rst,nxtodd,odd);

assign nxtodd = |inami? !odd : odd;

reg [3:0] oposrg;
reg [3:0] onegrg;

wire      shftposin;//pos and neg datain
wire      shftnegin;

wire      zeropat;
reg       boovpar;

assign    zeropat  = (inami == 2'b00) && (oposrg[2:0] == 3'b000) && (onegrg[2:0] == 3'b000);

always@(posedge clk)
    begin
    if(rst)
        begin
        oposrg  <= 4'b1010;
        onegrg  <= 4'b0101;
        boovpar <= 1'b0;
        end
    else
        if(zeropat &&
           !odd)
            begin
            oposrg[0] <= !oposrg[3];
            onegrg[0] <= !onegrg[3];
            oposrg[1] <= 1'b0;
            onegrg[1] <= 1'b0;
            oposrg[2] <= 1'b0;
            onegrg[2] <= 1'b0;
            oposrg[3] <= !oposrg[3];
            onegrg[3] <= !onegrg[3];
            boovpar   <= !boovpar;
            end
        else if(zeropat && odd)
            begin
            oposrg[3] <= 1'b0;
            onegrg[3] <= 1'b0;
            oposrg[2] <= 1'b0;
            onegrg[2] <= 1'b0;
            oposrg[1] <= 1'b0;
            onegrg[1] <= 1'b0;
            oposrg[0] <= oposrg[3];
            onegrg[0] <= onegrg[3];
            end
        else
            begin
            oposrg  <=  {oposrg[2:0],shftposin};
            onegrg  <=  {onegrg[2:0],shftnegin};
            end
    end

assign shftposin = (inami == 2'b00)? 1'b0 : (boovpar)? !inami[1] : inami[1];
assign shftnegin = (inami == 2'b00)? 1'b0 : (boovpar)? !inami[0] : inami[0];

assign opos = oposrg[3];
assign oneg = onegrg[3];

endmodule 
