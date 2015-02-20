library IEEE;
library STD;
use WORK.divider_const.all;
use IEEE.std_logic_1164.all;
use ieee.std_logic_textio.all; 
use std.textio.all;
use IEEE.numeric_std.all;


entity comb_divider_tb is
  --No inputs or outputs
end entity ; -- comb_divider_tb



architecture arch of comb_divider_tb is

	component divider is
	port(
	 clk : in std_logic;
	 start : in std_logic;
	 dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
	 divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	 --Outputs
	 quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
	 remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	 overflow : out std_logic
	 );
	end component divider;
	for all : divider use entity WORK.divider (behavioral_sequential);
		signal clk : std_logic := '0';
		signal in1 : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
		signal in2 : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
		signal tempQuotient : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
		signal tempRemainder : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
		signal tempOverflow : std_logic;
		signal tempStart : std_logic;
	begin
		clk <= not clk after 5 ns;

		c1:divider port map(clk,tempStart,in1,in2,tempQuotient,tempRemainder,tempOverflow);

		process is
			variable my_line : line;
			--file infile: text open read_mode is "C:\Users\Peter\Documents\GitHub\355HWs\asgn2\16bit.in";
			file infile: text open read_mode is "16bit.in";
			file outfile: text open write_mode is "16bit.out";
			variable num : integer;
			begin
				write(my_line, string'("Beginning to test..."));
				writeline(outfile, my_line);

				while not (endfile(infile)) loop
					tempStart<='0';
					--first int
					readline(infile, my_line);
					read(my_line, num);

					in1<=std_logic_vector(to_unsigned(num, DIVIDEND_WIDTH));
          
					--second int
					readline(infile, my_line);
					read(my_line, num);

					in2<=std_logic_vector(to_unsigned(num, DIVISOR_WIDTH));
					wait for 2 ns;
					tempStart<='1';
					wait for 400 ns;
					tempStart<='0';
					
					wait for 2 ns;
				
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