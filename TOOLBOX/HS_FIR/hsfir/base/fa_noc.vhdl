library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fa_noc is
  
  port (
    in1, in2, in3 : in  std_logic;
    outs          : out std_logic);

end fa_noc;

architecture behav of fa_noc is

begin  -- behav

  outs <= in1 xor in2 xor in3;

end behav;
