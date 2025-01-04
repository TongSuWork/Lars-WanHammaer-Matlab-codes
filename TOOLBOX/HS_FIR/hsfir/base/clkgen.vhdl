library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clkgen is

  generic (
    period : time);

  port (
    clk : out std_logic;
    reset : out std_logic);

end clkgen;

architecture behav of clkgen is

begin

  clkgen: process
  begin  -- process clkgen
    clk <= '0';
    wait for period/2;
    clk <= '1';
    wait for period/2;
  end process clkgen;

  reset <= '0', '1' after period;

end behav;
