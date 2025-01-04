library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity stimgen is

  generic (
    stimfn : string;
    wordlength : integer);

  port (
    clk : in std_logic;
    reset : in std_logic;
    data : out std_logic_vector(wordlength-1 downto 0));

end stimgen;

architecture behav of stimgen is

begin

  stimp: process
    variable l : line;
    file f : text open read_mode is stimfn;
    variable d : std_logic_vector(wordlength-1 downto 0);
  begin  -- process stimp
    wait until reset = '1';
    loop 
      readline(f, l);
      read(l, d);
      data <= d;
      wait until rising_edge(clk);
    end loop;
  end process stimp;

end behav;
