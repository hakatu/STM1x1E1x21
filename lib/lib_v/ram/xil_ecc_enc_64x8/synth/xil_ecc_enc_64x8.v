(* X_CORE_INFO = "ecc_v2_0,Vivado 2015.2" *)
(* CHECK_LICENSE_TYPE = "xil_ecc_enc_64x8,ecc_v2_0,{}" *)
(* CORE_GENERATION_INFO = "xil_ecc_enc_64x8,ecc_v2_0,{x_ipProduct=Vivado 2015.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=ecc,x_ipVersion=2.0,x_ipCoreRevision=8,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,C_FAMILY=virtexu,C_COMPONENT_NAME=xil_ecc_enc_64x8,C_ECC_MODE=0,C_ECC_TYPE=0,C_DATA_WIDTH=64,C_CHK_BIT_WIDTH=8,C_REG_INPUT=1,C_REG_OUTPUT=1,C_PIPELINE=1,C_USE_CLK_ENABLE=1}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module xil_ecc_enc_64x8 (
  ecc_clk,
  ecc_reset,
  ecc_clken,
  ecc_data_in,
  ecc_data_out,
  ecc_chkbits_out
);

(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ecc_clk CLK" *)
input wire ecc_clk;
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ecc_reset RST" *)
input wire ecc_reset;
(* X_INTERFACE_INFO = "xilinx.com:signal:clockenable:1.0 ecc_clken CE" *)
input wire ecc_clken;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_DATA_IN DATA" *)
input wire [63 : 0] ecc_data_in;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_DATA_OUT DATA" *)
output wire [63 : 0] ecc_data_out;
(* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 ECC_CHKBITS_OUT DATA" *)
output wire [7 : 0] ecc_chkbits_out;

  ecc_v2_0 #(
    .C_FAMILY("virtexu"),
    .C_COMPONENT_NAME("xil_ecc_enc_64x8"),
    .C_ECC_MODE(0),
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
    .ecc_correct_n(1'B0),
    .ecc_clken(ecc_clken),
    .ecc_data_in(ecc_data_in),
    .ecc_data_out(ecc_data_out),
    .ecc_chkbits_out(ecc_chkbits_out),
    .ecc_chkbits_in(8'B0),
    .ecc_sbit_err(),
    .ecc_dbit_err()
  );
endmodule
