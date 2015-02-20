library ieee;
use ieee.std_logic_1164.all;

entity ffarray is
  generic (
    n   : integer
  );
  port (
	clk	: in  std_logic;
	d	: in  std_logic_vector(n-1 downto 0);
	q	: out  std_logic_vector(n-1 downto 0)
  ) ;
end ffarray; -- ffarray

architecture arch of ffarray is

	component dff is
  port (
	clk	: in  std_logic;
	d	: in  std_logic;
	q	: out std_logic
  );
end component; 

begin
	f1: for i in 0 to (n-1) generate
		ff: dff port map (clk=>clk, d=>d(i), q=>q(i));
	end generate;
	 
end architecture ; -- arch