library IEEE;
library STD;
use WORK.divider_const.all;
use IEEE.std_logic_1164.all;
use ieee.std_logic_textio.all; 
use std.textio.all;
use IEEE.numeric_std.all;


entity comparator_tb is
  --No inputs or outputs
end entity ; -- comparator_tb



architecture arch of comparator_tb is

	component comparator is
	generic(
		DATA_WIDTH : natural := 8
	);
	port(
		--Inputs
		DINL : in std_logic_vector (DATA_WIDTH downto 0);
		DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
 		--Outputs
 		DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
		isGreaterEq : out std_logic
	);
	end component;

	signal inLVariable : std_logic_vector (8 downto 0);
	signal inRVariable : std_logic_vector (8 -1 downto 0);
	signal outTemp : std_logic_vector (8 -1 downto 0);
	signal greaterTemp : std_logic;

	begin

		c1: comparator port map(inLVariable,inRVariable,outTemp,greaterTemp);

		process is
		begin
			inLVariable<="000000001";
			inRVariable<="00000100";
			wait for 10 ns;
			inRVariable<="10100101";
			wait for 10 ns;
			inLVariable<="101000001";
			inRVariable<="11110010";
			wait;
			
		end process;
end architecture ; -- arch