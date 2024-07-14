//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
xil_ecc_enc_64x8 your_instance_name (
  .ecc_clk(ecc_clk),                  // input wire ecc_clk
  .ecc_reset(ecc_reset),              // input wire ecc_reset
  .ecc_clken(ecc_clken),              // input wire ecc_clken
  .ecc_data_in(ecc_data_in),          // input wire [63 : 0] ecc_data_in
  .ecc_data_out(ecc_data_out),        // output wire [63 : 0] ecc_data_out
  .ecc_chkbits_out(ecc_chkbits_out)  // output wire [7 : 0] ecc_chkbits_out
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file xil_ecc_enc_64x8.v when simulating
// the core, xil_ecc_enc_64x8. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

