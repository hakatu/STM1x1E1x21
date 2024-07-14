(* X_CORE_INFO = "ecc_v2_0,Vivado 2015.2" *)
module xil_ecc_enc_64x8(ecc_clk, ecc_reset, ecc_clken, ecc_data_in, ecc_data_out, ecc_chkbits_out)
/* synthesis syn_black_box black_box_pad_pin="ecc_clk,ecc_reset,ecc_clken,ecc_data_in[63:0],ecc_data_out[63:0],ecc_chkbits_out[7:0]" */;
  input ecc_clk;
  input ecc_reset;
  input ecc_clken;
  input [63:0]ecc_data_in;
  output [63:0]ecc_data_out;
  output [7:0]ecc_chkbits_out;
endmodule
