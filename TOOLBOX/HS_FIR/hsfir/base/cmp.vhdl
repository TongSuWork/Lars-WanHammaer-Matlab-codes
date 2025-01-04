library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cmp is

  generic (
    wordlength : integer);

  port (
    x1 : in std_logic_vector(wordlength-1 downto 0);
    x2 : in std_logic_vector(wordlength-1 downto 0);
    y : out std_logic);

end cmp;

architecture behav of cmp is

begin

  y <= transport '0' when x1 = x2 else '1' after 1 ns;

end behav;
