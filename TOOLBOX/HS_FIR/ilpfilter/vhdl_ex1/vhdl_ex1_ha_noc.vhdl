library ieee;use ieee.std_logic_1164.all;use ieee.numeric_std.all;entity ha_noc is    port (    in1, in2 : in  std_logic;    outs     : out std_logic);end ha_noc;architecture behav of ha_noc isbegin  -- behav  outs <= in1 xor in2;end behav;