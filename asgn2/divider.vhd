-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;


entity divider is
port(
	--Inputs
	-- clk : in std_logic;
	--COMMENT OUT clk signal for Part A.
 	start : in std_logic;
 	dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
 	divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
 	--Outputs
 	quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
 	remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
 	overflow : out std_logic
 	);
end entity divider;

architecture structural_combinational of divider is
	--Signals
	type data_array is array(0 to (DIVIDEND_WIDTH-DIVISOR_WIDTH)) of std_logic_vector(DIVISOR_WIDTH downto 0);
	signal datal_array : data_array;
	signal dout_temp : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal dividend_temp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
	signal divisor_temp : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	--Components
	component comparator
 	generic(
 		DATA_WIDTH : natural := 4
 		);
	port(
 		DINL : in std_logic_vector (DATA_WIDTH downto 0);
 		DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
 		DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
 		isGreaterEq : out std_logic
 		);
	end component comparator;

begin
	--process for start button
	process(start,dividend,divisor)
	begin
		if start='1' then
			dividend_temp<=dividend;
			divisor_temp<=divisor;
		end if;
	end process;

	--set first element of datal_array	
	datal_array(0)<="0"&dividend_temp(DIVIDEND_WIDTH-1 downto DIVIDEND_WIDTH-DIVISOR_WIDTH); --concatenate '0' at beginning to get correct vector length
	--network of comparators
	COMPARE:
	for i in 1 to (DIVIDEND_WIDTH-DIVISOR_WIDTH+1) generate
		comp: comparator
			generic map (DATA_WIDTH=>DIVISOR_WIDTH)
			port map (DINL=>datal_array(i-1), DINR=>divisor_temp, DOUT=>dout_temp, isGreaterEq=>quotient(DIVIDEND_WIDTH-DIVISOR_WIDTH+1-i));
			datal_array(i)<=dout_temp(DIVISOR_WIDTH-1 downto 0)&dividend_temp(DIVISOR_WIDTH-DIVISOR_WIDTH+1-i);
	end generate;
	--set remainder
	remainder<=datal_array(DIVIDEND_WIDTH-DIVISOR_WIDTH)(DIVISOR_WIDTH-1 downto 0);

end architecture structural_combinational;
----------------------------------------------------------------------------- 