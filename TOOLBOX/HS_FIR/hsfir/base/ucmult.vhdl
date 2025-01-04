library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ucmult is

  generic (
    win : positive;
    wout : positive;
    c : integer);
  
  port (
    din  : in  std_logic_vector(win-1 downto 0);
    dout : out std_logic_vector(wout-1 downto 0));

end ucmult;

architecture behav of ucmult is

begin  -- behav

  dout <= std_logic_vector(unsigned(din) * to_unsigned(c, wout-win));

end behav;
