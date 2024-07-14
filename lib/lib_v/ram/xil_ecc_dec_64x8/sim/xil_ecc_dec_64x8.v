`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module xil_ecc_dec_64x8 (
  ecc_clk,
  ecc_reset,
  ecc_correct_n,
  ecc_clken,
  ecc_data_in,
  ecc_data_out,
  ecc_chkbits_in,
  ecc_sbit_err,
  ecc_dbit_err
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ecc_clk CLK" *)
input wire ecc_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ecc_reset RST" *)
input wire ecc_reset;
input wire ecc_correct_n;
(* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 ecc_clken CE" *)
input wire ecc_clken;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_DATA_IN DATA" *)
input wire [63 : 0] ecc_data_in;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_DATA_OUT DATA" *)
output wire [63 : 0] ecc_data_out;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_CHKBITS_IN DATA" *)
input wire [7 : 0] ecc_chkbits_in;
output wire ecc_sbit_err;
output wire ecc_dbit_err;

  ecc_v2_0 #(
    .C_FAMILY("virtexu"),
    .C_COMPONENT_NAME("xil_ecc_dec_64x8"),
    .C_ECC_MODE(1),
    .C_ECC_TYPE(0),
    .C_DATA_WIDTH(64),
    .C_CHK_BIT_WIDTH(8),
    .C_REG_INPUT(1),
    .C_REG_OUTPUT(1),
    .C_PIPELINE(1),
    .C_USE_CLK_ENABLE(1)
  ) inst (
    .ecc_clk(ecc_clk),
    .ecc_reset(ecc_reset),
    .ecc_encode(1'B0),
    .ecc_correct_n(ecc_correct_n),
    .ecc_clken(ecc_clken),
    .ecc_data_in(ecc_data_in),
    .ecc_data_out(ecc_data_out),
    .ecc_chkbits_out(),
    .ecc_chkbits_in(ecc_chkbits_in),
    .ecc_sbit_err(ecc_sbit_err),
    .ecc_dbit_err(ecc_dbit_err)
  );
endmodule
