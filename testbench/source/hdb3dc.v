// Filename     : hdb3dc.v
// Description  : epos and eneg both need to be deasserted to register bit 0
//                This design has not included HDB3 Error check
////////////////////////////////////////////////////////////////////////////////

module hdb3dc
    (
     clk,
     rst,

     epos,  //input from HDB3 LIU
     eneg,

     enrz // to framer
     );

////////////////////////////////////////////////////////////////////////////////
// Port declarations

input   clk;
input   rst;

input   epos;
input   eneg;

output  enrz;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

////////////////////////////////////////////////////////////////////////////////
// Local signal declarations

wire    eshfin; //input of shift register
wire    epos;
wire    eneg;
    
////////////////////////////////////////////////////////////////////////////////
// Parameter declarations

////////////////////////////////////////////////////////////////////////////////
// FF the input

//fflopx #(2) ffinputi(clk,rst,{epos_i,eneg_i},{epos,eneg})

////////////////////////////////////////////////////////////////////////////////
// shift register

wire     [4:0] shftrg;       //shift register
wire          ezp;         //4 bit 0 pattern next value

fflopx #(5) shftrgi (clk,rst,{shftrg[3:0],eshfin},shftrg);

assign  eshfin  =   epos ^ eneg;
assign  ezp  = (shftrg[3] & !shftrg[2] & !shftrg[1] & shftrg[0]) ^
                  (!shftrg[3] & !shftrg[2] & !shftrg[1] & shftrg[0]);

////////////////////////////////////////////////////////////////////////////////
//Violation check
//Last polar initial state 0 is safe.Odd and even logic

reg     [1:0]   lastpolar1;
wire    [1:0]   lastpolar2;//fix violation jitter
wire            evlt;
wire            evltnxt;
 
always @ (posedge clk)
    begin
    if(rst)
        begin
        lastpolar1  <= 2'b00;
        end
    else
        case({epos,eneg})
            2'b00   :   lastpolar1 <= lastpolar1; //keep old value because 0
            2'b10   :   lastpolar1 <= 2'b10;
            2'b01   :   lastpolar1 <= 2'b01;
            default :   lastpolar1 <= 2'b00;  //safe, dont care
        endcase
    end //end always

fflopx #(1) ffvlti  (clk,rst,evltnxt,evlt);
fflopx #(2) ffpolari(clk,rst,lastpolar1,lastpolar2);

assign evltnxt = (epos & lastpolar2[1]) | (eneg & lastpolar2[0]); //violation

////////////////////////////////////////////////////////////////////////////////
//Zero pattern state machine
wire   ezpnv;

assign ezpnv = ezp & evlt; //True condition = matched pattern and violation

reg         estforce;
reg [1:0]   ezcnt;

always@(posedge clk)
    begin
    if(rst)
        begin
        estforce <= 1'b1;
        ezcnt <= 2'b00;
        end
    else
        if(ezpnv)
            begin
            ezcnt      <= 2'b11;
            estforce   <= 1'b0;
            end
        else
            begin
            if(ezcnt != 2'b00)//if(!ezcnt) is the same
                begin   
                ezcnt <= ezcnt - 2'b01;
                estforce <= 1'b0;
                end
            else
                estforce <= 1'b1;
            end
     end//end always
////////////////////////////////////////////////////////////////////////////////
//Final output assignment

assign enrz = shftrg[4] & estforce;
             
endmodule 
