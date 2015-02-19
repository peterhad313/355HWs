-----------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use WORK.divider_const.all;
use ieee.numeric_std.all;

entity divider is
port(
	--Inputs
	clk : in std_logic;
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

-------------------------------------------------------------------------------------------------

architecture structural_combinational of divider is
	--Signals
	type data_array is array(0 to (DIVIDEND_WIDTH-1)) of std_logic_vector(DIVISOR_WIDTH downto 0);
 	type data_array_short is array(1 to DIVIDEND_WIDTH) of std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal datal_array : data_array;
  	signal comp_out_array: data_array_short;
	signal dout_temp : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal quo_temp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  	signal rem_temp : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);

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
	--process for start button and overflow
	process(start,dividend,divisor)
	begin
		if start='1' then		
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
	datal_array(0)<="00000000"&dividend(DIVIDEND_WIDTH-1); --concatenate '0' at beginning to get correct vector length
 

	--network of comparators
	COMPARE:
	for i in 1 to (DIVIDEND_WIDTH-1) generate
		comp: comparator
			generic map (DATA_WIDTH=>DIVISOR_WIDTH)
			port map (DINL=>datal_array(i-1),
			DINR=>divisor, 
			DOUT=>comp_out_array(i), 
			isGreaterEq=>quo_temp(DIVIDEND_WIDTH-i));
			datal_array(i) <= comp_out_array(i)&dividend(DIVIDEND_WIDTH-1-i);
	end generate;
--	
	--Assign last bit of division
	comp: comparator
			generic map (DATA_WIDTH=>DIVISOR_WIDTH)
			port map (DINL=>datal_array(DIVIDEND_WIDTH-1),
			DINR=>divisor, 
			DOUT=>rem_temp, 
			isGreaterEq=>quo_temp(0));

end architecture structural_combinational;

-----------------------------------------------------------------------------

architecture behavioral_sequential of divider is
 	type data_array is array(0 to (DIVIDEND_WIDTH-1)) of std_logic_vector(DIVISOR_WIDTH downto 0);
 	type data_array_short is array(1 to DIVIDEND_WIDTH) of std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal datal_array : data_array;
  	signal comp_out_array: data_array_short;
	signal dout_temp : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
	signal quo_temp : std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
  	signal rem_temp : std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
  	signal comparatorIN : std_logic_vector(DIVISOR_WIDTH downto 0);
 	signal comparatorOUT : std_logic_vector(DIVISOR_WIDTH-1 downto 0);
 	signal comparatorResult : std_logic;

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
	process(start,dividend,divisor)
	--Variables
	variable count : integer := 1;
	begin
		--start button and overflow
--		if start='1' then		
--			if (to_integer(unsigned(divisor))=0) then
--				overflow<='1';
--				quotient<= quo_temp;
--			  	remainder <= rem_temp;
--			else 
--				overflow<='0';
--				quotient<= quo_temp;
--			  	remainder <= rem_temp;
--			end if;
--		end if;

		--set first element of datal_array	
		datal_array(0)<="00000000"&dividend(DIVIDEND_WIDTH-1); --concatenate '0' at beginning to get correct vector length
 
		--comparator loop
		COMPARE : while count<=DIVIDEND_WIDTH-1 loop  
			if(rising_edge(clk)) then
				--set inputs and outputs to comparator
				comparatorIN<=datal_array(count-1);
				comp_out_array(count)<=comparatorOUT;
				quo_temp(DIVIDEND_WIDTH-count)<=comparatorResult;

				--Update datal_array
				datal_array(count) <= comp_out_array(count)&dividend(DIVIDEND_WIDTH-1-count);

				--increment count
				count:=count+1;
			end if;
		end loop ; -- COMPARE
	--	
		--Assign last bit of division with one final comparator
		comparatorIN<=datal_array(DIVIDEND_WIDTH-1);
		rem_temp<=comparatorOUT;
		quo_temp(0)<=comparatorResult;

		--Assign overflow
		if (to_integer(unsigned(divisor))=0) then
			overflow<='1';
			quotient<= quo_temp;
		  	remainder <= rem_temp;
		else 
			overflow<='0';
			quotient<= quo_temp;
		  	remainder <= rem_temp;
		end if;
		
	end process;

 
 end architecture ; -- behavioral_sequential 