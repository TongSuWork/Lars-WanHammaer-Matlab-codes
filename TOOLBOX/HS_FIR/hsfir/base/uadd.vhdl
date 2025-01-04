library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uadd is

  generic (
    w : positive);
  
  port (
    din1 : in  std_logic_vector(w-1 downto 0);
    din2 : in  std_logic_vector(w-1 downto 0);
    dout : out std_logic_vector(w-1 downto 0));

end uadd;

architecture behav of uadd is

begin  -- behav

  dout <= std_logic_vector(unsigned(din1) + unsigned(din2));

end behav;
