library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ha is
  
  port (
    in1, in2   : in  std_logic;
    outs, outc : out std_logic);

end ha;

architecture behav of ha is

begin  -- behav

  outs <= in1 xor in2;
  outc <= (in1 and in2);

end behav;
