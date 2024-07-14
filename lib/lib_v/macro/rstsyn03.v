// Filename     : rstmap.v
// Description  : create sync reset per clock.
////////////////////////////////////////////////////////////////////////////////

module rstsyn03
    (
     rst_,
     clk,
     scanmode,
     rstmsk,
     orst_
     );

////////////////////////////////////////////////////////////////////////////////
// Parameter declarations



////////////////////////////////////////////////////////////////////////////////
// Port declarations

input           rst_;
input  [2:0]    clk;
input           scanmode;
input  [2:0]    rstmsk;
output [2:0]    orst_;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

wire    [2:0]   orst_;


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation

rstsyn01 rstm0  (rst_, clk[0],  scanmode, rstmsk[0],  orst_[0]);
rstsyn01 rstm1  (rst_, clk[1],  scanmode, rstmsk[1],  orst_[1]);
rstsyn01 rstm2  (rst_, clk[2],  scanmode, rstmsk[2],  orst_[2]);
 
endmodule 

