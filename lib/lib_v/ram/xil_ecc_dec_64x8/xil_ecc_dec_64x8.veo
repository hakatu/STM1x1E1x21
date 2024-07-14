//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
xil_ecc_dec_64x8 your_instance_name (
  .ecc_clk(ecc_clk),                // input wire ecc_clk
  .ecc_reset(ecc_reset),            // input wire ecc_reset
  .ecc_correct_n(ecc_correct_n),    // input wire ecc_correct_n
  .ecc_clken(ecc_clken),            // input wire ecc_clken
  .ecc_data_in(ecc_data_in),        // input wire [63 : 0] ecc_data_in
  .ecc_data_out(ecc_data_out),      // output wire [63 : 0] ecc_data_out
  .ecc_chkbits_in(ecc_chkbits_in),  // input wire [7 : 0] ecc_chkbits_in
  .ecc_sbit_err(ecc_sbit_err),      // output wire ecc_sbit_err
  .ecc_dbit_err(ecc_dbit_err)      // output wire ecc_dbit_err
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file xil_ecc_dec_64x8.v when simulating
// the core, xil_ecc_dec_64x8. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.

