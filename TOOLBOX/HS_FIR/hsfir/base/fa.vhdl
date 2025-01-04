library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fa is
  
  port (
    in1, in2, in3 : in  std_logic;
    outs, outc    : out std_logic);

end fa;

architecture behav of fa is

begin  -- behav

  outs <= in1 xor in2 xor in3;
  outc <= (in1 and in2) or (in1 and in3) or (in2 and in3);

end behav;
