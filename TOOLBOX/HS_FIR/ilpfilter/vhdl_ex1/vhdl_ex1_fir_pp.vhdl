library ieee;use ieee.std_logic_1164.all;entity fir_pp isport (clk, reset : in std_logic;  in_0 : in std_logic_vector(3 downto 0);  in_1 : in std_logic_vector(3 downto 0);  in_2 : in std_logic_vector(3 downto 0);  in_3 : in std_logic_vector(3 downto 0);  out_1_4 : out std_logic_vector(3 downto 0);  out_1_5 : out std_logic_vector(7 downto 0);  out_1_6 : out std_logic_vector(13 downto 0);  out_1_7 : out std_logic_vector(17 downto 0);  out_1_8 : out std_logic_vector(13 downto 0);  out_1_9 : out std_logic_vector(9 downto 0);  out_1_10 : out std_logic_vector(3 downto 0));end fir_pp;architecture generated of fir_pp iscomponent reggeneric (wordlength : positive);port (clk, reset : in std_logic;d : in std_logic_vector(wordlength-1 downto 0);q : out std_logic_vector(wordlength-1 downto 0));end component;signal in_0_0 : std_logic_vector(3 downto 0);signal in_0_1 : std_logic_vector(3 downto 0);signal in_1_0 : std_logic_vector(3 downto 0);signal in_1_1 : std_logic_vector(3 downto 0);signal in_2_0 : std_logic_vector(3 downto 0);signal in_2_1 : std_logic_vector(3 downto 0);signal in_2_2 : std_logic_vector(3 downto 0);signal in_3_0 : std_logic_vector(3 downto 0);signal in_3_1 : std_logic_vector(3 downto 0);signal in_3_2 : std_logic_vector(3 downto 0);beginin_0_0 <= in_0;in_d_0_1: reg generic map(4) port map(clk, reset, in_0_0, in_0_1);in_1_0 <= in_1;in_d_1_1: reg generic map(4) port map(clk, reset, in_1_0, in_1_1);in_2_0 <= in_2;in_d_2_1: reg generic map(4) port map(clk, reset, in_2_0, in_2_1);in_d_2_2: reg generic map(4) port map(clk, reset, in_2_1, in_2_2);in_3_0 <= in_3;in_d_3_1: reg generic map(4) port map(clk, reset, in_3_0, in_3_1);in_d_3_2: reg generic map(4) port map(clk, reset, in_3_1, in_3_2);out_1_4(0) <= in_0_0(3);out_1_4(1) <= in_3_1(3);out_1_4(2) <= in_2_1(3);out_1_4(3) <= in_1_1(3);out_1_5(0) <= in_1_0(3);out_1_5(1) <= in_0_0(2);out_1_5(2) <= in_3_1(2);out_1_5(3) <= in_3_1(3);out_1_5(4) <= in_2_1(2);out_1_5(5) <= in_2_1(3);out_1_5(6) <= in_1_1(2);out_1_5(7) <= in_0_1(3);out_1_6(0) <= in_2_0(3);out_1_6(1) <= in_1_0(2);out_1_6(2) <= in_1_0(3);out_1_6(3) <= in_0_0(1);out_1_6(4) <= in_0_0(3);out_1_6(5) <= in_3_1(1);out_1_6(6) <= in_3_1(2);out_1_6(7) <= in_2_1(1);out_1_6(8) <= in_2_1(2);out_1_6(9) <= in_1_1(1);out_1_6(10) <= in_1_1(3);out_1_6(11) <= in_0_1(2);out_1_6(12) <= in_0_1(3);out_1_6(13) <= in_3_2(3);out_1_7(0) <= in_3_0(3);out_1_7(1) <= in_2_0(2);out_1_7(2) <= in_2_0(3);out_1_7(3) <= in_1_0(1);out_1_7(4) <= in_1_0(2);out_1_7(5) <= in_0_0(0);out_1_7(6) <= in_0_0(2);out_1_7(7) <= in_3_1(0);out_1_7(8) <= in_3_1(1);out_1_7(9) <= in_2_1(0);out_1_7(10) <= in_2_1(1);out_1_7(11) <= in_1_1(0);out_1_7(12) <= in_1_1(2);out_1_7(13) <= in_0_1(1);out_1_7(14) <= in_0_1(2);out_1_7(15) <= in_3_2(2);out_1_7(16) <= in_3_2(3);out_1_7(17) <= in_2_2(3);out_1_8(0) <= in_3_0(2);out_1_8(1) <= in_2_0(1);out_1_8(2) <= in_2_0(2);out_1_8(3) <= in_1_0(0);out_1_8(4) <= in_1_0(1);out_1_8(5) <= in_0_0(1);out_1_8(6) <= in_3_1(0);out_1_8(7) <= in_2_1(0);out_1_8(8) <= in_1_1(1);out_1_8(9) <= in_0_1(0);out_1_8(10) <= in_0_1(1);out_1_8(11) <= in_3_2(1);out_1_8(12) <= in_3_2(2);out_1_8(13) <= in_2_2(2);out_1_9(0) <= in_3_0(1);out_1_9(1) <= in_2_0(0);out_1_9(2) <= in_2_0(1);out_1_9(3) <= in_1_0(0);out_1_9(4) <= in_0_0(0);out_1_9(5) <= in_1_1(0);out_1_9(6) <= in_0_1(0);out_1_9(7) <= in_3_2(0);out_1_9(8) <= in_3_2(1);out_1_9(9) <= in_2_2(1);out_1_10(0) <= in_3_0(0);out_1_10(1) <= in_2_0(0);out_1_10(2) <= in_3_2(0);out_1_10(3) <= in_2_2(0);end generated;