-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use ieee.numeric_std.all;

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
	type data_array is array(0 to (DIVIDEND_WIDTH-1)) of std_logic_vector(DIVISOR_WIDTH downto 0);
 --SEDA_COMMENT: I introduced an additional array for comparator outputs
 	type data_array_short is array(1 to DIVIDEND_WIDTH) of std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal datal_array : data_array;
  signal comp_out_array: data_array_short;
	signal dout_temp : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
--	signal dividend_temp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
--	signal divisor_temp : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	signal quo_temp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  signal rem_temp : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);

	--Components
	component comparator
 	generic(
 		DATA_WIDTH : natural := 16
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
		  
		  
--		  overflow <= divisor(0);
--			dividend_temp<=dividend;
--			divisor_temp<=divisor;
--SEDA_COMMENT: need to compute overflow with start button control as well
--SEDA_COMMENT: tried controlling release of output rather than input			
		if (to_integer(unsigned(divisor))=0) then
			overflow<='1';
			quotient<= quo_temp;
		  remainder <= rem_temp;
		else 
			overflow<='0';
			quotient<= quo_temp;
		  remainder <= rem_temp;
		end if;
		end if;
	end process;

	--set first element of datal_array	
	-- add divisor length 0's
datal_array(0)<="0000"&dividend(DIVIDEND_WIDTH-1); --concatenate '0' at beginning to get correct vector length
 
--
--	--network of comparators
	COMPARE:
	for i in 1 to (DIVIDEND_WIDTH-1) generate
		comp: comparator
			generic map (DATA_WIDTH=>DIVISOR_WIDTH)
			port map (DINL=>datal_array(i-1),
			DINR=>divisor, 
			DOUT=>comp_out_array(i), 
			isGreaterEq=>quo_temp(DIVIDEND_WIDTH-i));
----
datal_array(i) <= comp_out_array(i)&dividend(DIVIDEND_WIDTH-1-i);
--SEDA_COMMENT: AT THE LAST ITERATION THIS WILL PLACE THE LAST DINL value to the array
	end generate;
--	
--	--SEDA_COMMENT: NEED TO ASSIGN THE LAST BIT OF DIVISION RESULT HERE, USING THE LAST VALUE OF THE ARRAY
	comp: comparator
			generic map (DATA_WIDTH=>DIVISOR_WIDTH)
			port map (DINL=>datal_array(DIVIDEND_WIDTH-1),
			DINR=>divisor, 
			DOUT=>rem_temp, 
			isGreaterEq=>quo_temp(0));

	--set remainder
----	remainder<=datal_array(DIVIDEND_WIDTH-DIVISOR_WIDTH)(DIVISOR_WIDTH-1 downto 0);
----
----process for overflow check
----	process(start, dividend, divisor)
----	begin
--		--set overflow
----		if (to_integer(unsigned(divisor))=0) then
----			overflow<='1';
----		else 
----			overflow<='0';
----		end if;
----	end process;


end architecture structural_combinational;
----------------------------------------------------------------------------- 