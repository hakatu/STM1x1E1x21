// Filename     : rstpdh.v
// Description  : create sync reset per clock.
////////////////////////////////////////////////////////////////////////////////

module rstsyn02
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
input  [1:0]    clk;
input           scanmode;
input  [1:0]    rstmsk;
output [1:0]    orst_;

////////////////////////////////////////////////////////////////////////////////
// Output declarations

wire    [1:0]   orst_;


////////////////////////////////////////////////////////////////////////////////
// Local logic and instantiation


rstsyn01 rstm0  (rst_, clk[0],  scanmode, rstmsk[0],  orst_[0]);
rstsyn01 rstm1  (rst_, clk[1],  scanmode, rstmsk[1],  orst_[1]);

endmodule 

