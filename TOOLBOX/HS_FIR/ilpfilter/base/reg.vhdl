library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is

  generic (
    wordlength : positive);
  
  port (
    clk, reset : in  std_logic;
    d : in  std_logic_vector(wordlength-1 downto 0);
    q : out std_logic_vector(wordlength-1 downto 0));

end reg;

architecture behav of reg is

begin  -- behav

  p: process (clk, reset)
  begin  -- process p
    if reset = '0' then                 -- asynchronous reset (active low)
      q <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      q <= d;
    end if;
  end process p;

end behav;
