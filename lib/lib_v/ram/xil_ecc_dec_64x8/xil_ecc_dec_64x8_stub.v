(* X_CORE_INFO = "ecc_v2_0,Vivado 2015.2" *)
module xil_ecc_dec_64x8(ecc_clk, ecc_reset, ecc_correct_n, ecc_clken, ecc_data_in, ecc_data_out, ecc_chkbits_in, ecc_sbit_err, ecc_dbit_err)
/* synthesis syn_black_box black_box_pad_pin="ecc_clk,ecc_reset,ecc_correct_n,ecc_clken,ecc_data_in[63:0],ecc_data_out[63:0],ecc_chkbits_in[7:0],ecc_sbit_err,ecc_dbit_err" */;
  input ecc_clk;
  input ecc_reset;
  input ecc_correct_n;
  input ecc_clken;
  input [63:0]ecc_data_in;
  output [63:0]ecc_data_out;
  input [7:0]ecc_chkbits_in;
  output ecc_sbit_err;
  output ecc_dbit_err;
endmodule
