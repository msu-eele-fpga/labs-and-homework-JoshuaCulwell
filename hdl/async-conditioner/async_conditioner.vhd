library ieee;
use ieee.std_logic_1164.all;

entity async_conditioner is
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		async : in std_ulogic;
		sync : out std_ulogic
	);
end entity;

architecture async_conditioner_arch of async_conditioner is
	component synchronizer is
		port (
			clk : in std_ulogic;
			async : in std_ulogic;
			sync : out std_ulogic
		);
	end component;

	component debouncer is
		generic(
			clk_period : time := 20 ns;
			debounce_time : time
		);
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			input : in std_ulogic;
			debounced : out std_ulogic
		);
	end component;

	component one_pulse is
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			input : in std_ulogic;
			pulse: out std_ulogic
		);
	end component;

	constant CLK_PERIOD : time := 20 ns;
	constant DEBOUNCE_TIME : time := 100 ns;

	signal sync_input : std_ulogic;
	signal debounced : std_ulogic;

begin
	SYNCHRONIZER_component : synchronizer port map (clk => clk, async => async, sync => sync_input);
	DEBOUNCER_component : debouncer
		generic map(clk_period => CLK_PERIOD, debounce_time => DEBOUNCE_TIME)
		port map(clk => clk, rst => rst, input => sync_input, debounced => debounced);
	ONE_PULSE_component : one_pulse port map (clk => clk, rst => rst, input => debounced, pulse => sync);
end architecture;



	