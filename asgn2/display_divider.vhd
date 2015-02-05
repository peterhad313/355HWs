library IEEE;
use IEEE.std_logic_1164.all;
use work.decoder.all; --contains leddcd
use work.divider_const.all;
use ieee.numeric_std.all;

entity display_divider is
port(
	--Inputs
	start : in std_logic;
 	dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
 	divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
	--Outputs
	segments_quotient : out std_logic_vector(((7*DIVIDEND_WIDTH)/4-1) downto 0); --need 7 segments for each hex value
	segments_remainder : out std_logic_vector(((7*DIVISOR_WIDTH)/4-1) downto 0); --need 7 segments for each hex value
 	segments_overflow : out std_logic_vector(6 downto 0)
 );
end entity display_divider;

architecture structural of display_divider is
--Signals
signal start_not : std_logic;
signal quotient : std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
signal remainder : std_logic_vector(DIVISOR_WIDTH-1 downto 0); 
signal overflow : std_logic;

--Components
component divider 
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
 end component;

begin
	--Flip start signal
	start_not <= not start;
	--Calculate quotient and remainder
	div: divider
		port map (start=>start_not, dividend=>dividend, divisor=>divisor, quotient=>quotient, remainder=>remainder, overflow=>overflow);
	--Display Quotient
	GEN_LED_Q: 
	for i in 1 to ((DIVIDEND_WIDTH)/4) generate
		led: leddcd
			port map (
				data_in=>quotient(((i*4)-1) downto ((i*4)-4)),
				segments_out=>segments_quotient((i*7-1) downto (i*7)-7));
	end generate;
	--Display Remainder
	GEN_LED_R: 
	for i in 1 to ((DIVISOR_WIDTH)/4) generate
		led: leddcd
			port map (
				data_in=>remainder(((i*4)-1) downto ((i*4)-4)),
				segments_out=>segments_remainder((i*7-1) downto (i*7)-7));
	end generate;
	--Display overflow
	led_over: leddcd port map(
		data_in=>"000"&overflow, segments_out=>segments_overflow);
	
end architecture structural; 