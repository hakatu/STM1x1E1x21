library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xil_ecc_dec_64x8 is
  Port ( 
    ecc_clk : in STD_LOGIC;
    ecc_reset : in STD_LOGIC;
    ecc_correct_n : in STD_LOGIC;
    ecc_clken : in STD_LOGIC;
    ecc_data_in : in STD_LOGIC_VECTOR ( 63 downto 0 );
    ecc_data_out : out STD_LOGIC_VECTOR ( 63 downto 0 );
    ecc_chkbits_in : in STD_LOGIC_VECTOR ( 7 downto 0 );
    ecc_sbit_err : out STD_LOGIC;
    ecc_dbit_err : out STD_LOGIC
  );

end xil_ecc_dec_64x8;

architecture stub of xil_ecc_dec_64x8 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "ecc_clk,ecc_reset,ecc_correct_n,ecc_clken,ecc_data_in[63:0],ecc_data_out[63:0],ecc_chkbits_in[7:0],ecc_sbit_err,ecc_dbit_err";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ecc_v2_0,Vivado 2015.2";
begin
end;
