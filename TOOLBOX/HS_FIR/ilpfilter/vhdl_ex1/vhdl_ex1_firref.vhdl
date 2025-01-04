library ieee;use ieee.std_logic_1164.all;use ieee.numeric_std.all;entity firref isport (  clk, reset : in std_logic;  x_0 : in std_logic_vector(3 downto 0);  x_1 : in std_logic_vector(3 downto 0);  x_2 : in std_logic_vector(3 downto 0);  x_3 : in std_logic_vector(3 downto 0);  y : out std_logic_vector(9 downto 0));end firref;architecture generated of firref iscomponent reggeneric (wordlength : positive);port (  clk, reset : in std_logic;  d : in std_logic_vector(wordlength-1 downto 0);  q : out std_logic_vector(wordlength-1 downto 0));end component;signal x_0_0 : std_logic_vector(3 downto 0);signal x_0_1 : std_logic_vector(3 downto 0);signal x_0_2 : std_logic_vector(3 downto 0);signal x_1_0 : std_logic_vector(3 downto 0);signal x_1_1 : std_logic_vector(3 downto 0);signal x_1_2 : std_logic_vector(3 downto 0);signal x_2_0 : std_logic_vector(3 downto 0);signal x_2_1 : std_logic_vector(3 downto 0);signal x_3_0 : std_logic_vector(3 downto 0);signal x_3_1 : std_logic_vector(3 downto 0);signal prod_0_0 : std_logic_vector(9 downto 0);signal prod_0_1 : std_logic_vector(9 downto 0);signal prod_0_2 : std_logic_vector(9 downto 0);signal prod_1_0 : std_logic_vector(9 downto 0);signal prod_1_1 : std_logic_vector(9 downto 0);signal prod_1_2 : std_logic_vector(9 downto 0);signal prod_2_0 : std_logic_vector(9 downto 0);signal prod_2_1 : std_logic_vector(9 downto 0);signal prod_3_0 : std_logic_vector(9 downto 0);signal prod_3_1 : std_logic_vector(9 downto 0);signal sum_0 : std_logic_vector(9 downto 0);signal sum_1 : std_logic_vector(9 downto 0);signal sum_2 : std_logic_vector(9 downto 0);signal sum_3 : std_logic_vector(9 downto 0);signal sum_4 : std_logic_vector(9 downto 0);constant c_0_0 : integer := 1;constant c_1_0 : integer := 3;constant c_2_0 : integer := 6;constant c_3_0 : integer := 10;constant c_0_1 : integer := 12;constant c_1_1 : integer := 12;constant c_2_1 : integer := 10;constant c_3_1 : integer := 6;constant c_0_2 : integer := 3;constant c_1_2 : integer := 1;beginx_0_0 <= x_3;x_1_0 <= x_2;x_2_0 <= x_1;x_3_0 <= x_0;xd_0_0_i : reg generic map(4) port map(clk, reset, x_0_0, x_0_1);xd_0_1_i : reg generic map(4) port map(clk, reset, x_0_1, x_0_2);xd_1_0_i : reg generic map(4) port map(clk, reset, x_1_0, x_1_1);xd_1_1_i : reg generic map(4) port map(clk, reset, x_1_1, x_1_2);xd_2_0_i : reg generic map(4) port map(clk, reset, x_2_0, x_2_1);xd_3_0_i : reg generic map(4) port map(clk, reset, x_3_0, x_3_1);prod_0_0 <= std_logic_vector(unsigned(x_0_0) * to_unsigned(c_0_0, 6));prod_0_1 <= std_logic_vector(unsigned(x_0_1) * to_unsigned(c_0_1, 6));prod_0_2 <= std_logic_vector(unsigned(x_0_2) * to_unsigned(c_0_2, 6));prod_1_0 <= std_logic_vector(unsigned(x_1_0) * to_unsigned(c_1_0, 6));prod_1_1 <= std_logic_vector(unsigned(x_1_1) * to_unsigned(c_1_1, 6));prod_1_2 <= std_logic_vector(unsigned(x_1_2) * to_unsigned(c_1_2, 6));prod_2_0 <= std_logic_vector(unsigned(x_2_0) * to_unsigned(c_2_0, 6));prod_2_1 <= std_logic_vector(unsigned(x_2_1) * to_unsigned(c_2_1, 6));prod_3_0 <= std_logic_vector(unsigned(x_3_0) * to_unsigned(c_3_0, 6));prod_3_1 <= std_logic_vector(unsigned(x_3_1) * to_unsigned(c_3_1, 6));sum_0 <= std_logic_vector(unsigned(prod_0_0) + unsigned(prod_0_1) + unsigned(prod_0_2) + unsigned(prod_1_0) + unsigned(prod_1_1) + unsigned(prod_1_2) + unsigned(prod_2_0) + unsigned(prod_2_1) + unsigned(prod_3_0) + unsigned(prod_3_1));sumd_0_i : reg generic map(10) port map(clk, reset, sum_0, sum_1);sumd_1_i : reg generic map(10) port map(clk, reset, sum_1, sum_2);sumd_2_i : reg generic map(10) port map(clk, reset, sum_2, sum_3);sumd_3_i : reg generic map(10) port map(clk, reset, sum_3, sum_4);y <= sum_4;end generated;