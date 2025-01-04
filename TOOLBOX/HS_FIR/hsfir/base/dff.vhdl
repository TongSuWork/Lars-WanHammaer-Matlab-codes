library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dff is
  
  port (
    clk, reset : in  std_logic;
    d : in  std_logic;
    q : out std_logic);

end dff;

architecture behav of dff is

begin  -- behav

  p: process (clk, reset)
  begin  -- process p
    if reset = '0' then                 -- asynchronous reset (active low)
      q <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      q <= d;
    end if;
  end process p;

end behav;
