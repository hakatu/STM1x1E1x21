// Filename     : ipsmacge_delay_k_clk.v
// Description  : 
////////////////////////////////////////////////////////////////////////////////

module ipsmacge_delay_k_clk
    (
     clk,
     rst_,
     idat,
     odat
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations
parameter K = 3;    //delay 3 clock cycle

////////////////////////////////////////////////////////////////////////////////
// Port declarations
input              clk,
                   rst_;
input              idat;
output             odat;
  
////////////////////////////////////////////////////////////////////////////////
// Output declarations
wire               odat;

////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation
reg [K-1:0] shift_dat;

always @ (posedge clk or negedge rst_)
    begin
    if(!rst_)    
        shift_dat <= {K{1'b0}};
    else        
        shift_dat <= {shift_dat[K-2:0],idat};
    end
assign odat = shift_dat[K-1];

endmodule 