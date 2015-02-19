-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity comparator is
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
end entity comparator;

architecture behavioral of comparator is
	--Signals and components go here
begin
	compute_diff: process(DINL, DINR)
	variable temp : integer;
	variable intDINL : integer;
	variable intDINR : integer;
	variable doutTemp: integer;

	begin
		--convert to integers
		intDINL:=to_integer(unsigned(DINL));
		intDINR:=to_integer(unsigned(DINR));

		temp:=intDINL-intDINR;
		--if less than, pass on DINL
		if (temp<0) then 
			doutTemp:= intDINL;
			isGreaterEq<='0';
		--Else subtract and set the output to 1
		else
			doutTemp:= temp;
			isGreaterEq<='1';
		end if;
		DOUT<=std_logic_vector(to_signed(doutTemp,DATA_WIDTH));

	end process;
	--Set DOUT from temp
end architecture behavioral;
