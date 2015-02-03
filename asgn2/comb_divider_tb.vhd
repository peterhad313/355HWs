library IEEE;
library STD;
use WORK.divider_const.all;
use IEEE.std_logic_1164.all;
use ieee.std_logic_textio.all; 
use std.textio.all;
use IEEE.numeric_std.all;


entity comb_divider_tb is
  port (
	sign : out std_logic
  ) ;
end entity ; -- comb_divider_tb



architecture arch of comb_divider_tb is

	component divider is
	port(
	 start : in std_logic;
	 dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
	 divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	 --Outputs
	 quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
	 remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	 overflow : out std_logic
	 );
	end component divider;

		signal in1 : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
		signal in2 : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
		signal tempQuotient : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
		signal tempRemainder : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
		signal tempOverflow : std_logic;
		signal tempStart : std_logic;
	begin

		c1:divider port map(tempStart,in1,in2,tempQuotient,tempRemainder,tempOverflow);
		sign<='1';

		process is
			variable my_line : line;
			file infile: text open read_mode is "16bit.in";
			file outfile: text open write_mode is "output.txt";
			variable num : integer;
			begin
				write(my_line, string'("Beginning to test..."));
				writeline(outfile, my_line);
				while not (endfile(infile)) loop
					--first int
					readline(infile, my_line);
					read(my_line, num);

					in1<=std_logic_vector(to_unsigned(num, DIVIDEND_WIDTH));

					--second int
					readline(infile, my_line);
					read(my_line, num);

					in2<=std_logic_vector(to_unsigned(num, DIVISOR_WIDTH));
					tempStart<='1';
					wait for 9 ns;
					tempStart<='0';
					write(my_line, to_integer(signed(in1)));
				    write(my_line, string'(" / "));
				    write(my_line, to_integer(signed(in2)));
				    write(my_line, string'(" = "));
				    write(my_line, to_integer(signed(tempQuotient)));
				    write(my_line, string'(" -- "));
				    write(my_line, to_integer(signed(tempRemainder)));

					-- Finally, write the line into the output file
					writeline(outfile, my_line);
					wait for 1 ns;
				end loop;  -- end file loop
			wait; -- wait forever at the end of the file
	end process;
end architecture ; -- arch