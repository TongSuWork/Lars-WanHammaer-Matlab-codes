library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scmult is

  generic (
    win : positive;
    wout : positive;
    c : integer);
  
  port (
    din  : in  std_logic_vector(win-1 downto 0);
    dout : out std_logic_vector(wout-1 downto 0));

end scmult;

architecture behav of scmult is

begin  -- behav

  dout <= std_logic_vector(signed(din) * to_signed(c, wout-win));

end behav;
