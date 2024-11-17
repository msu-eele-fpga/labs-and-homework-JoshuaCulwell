library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_controller_tb is
end entity;

architecture testbench of pwm_controller_tb is
	constant CLK_PERIOD : time := 10 ns;

	component pwm_controller is
	generic (
		CLK_PERIOD : time := 20 ns
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		period : in unsigned(16 - 1 downto 0);
		duty_cycle : in unsigned(12 - 1 downto 0);
		output : out std_logic
	);
	end component pwm_controller;

	signal clk_tb, rst_tb : std_ulogic := '0';
	signal period_tb : unsigned(15 downto 0);
	signal duty_cycle_tb : unsigned(11 downto 0);
	signal output_tb : std_logic;

begin
	dut : component pwm_controller port map(clk => clk_tb, rst => rst_tb, period => period_tb, duty_cycle => duty_cycle_tb, output => output_tb);

	clk_gen : process is
	begin
		clk_tb <= not clk_tb;
		wait for CLK_PERIOD / 2;
	end process clk_gen;

	stim : process is
	begin
		rst_tb <= '1';
		wait for CLK_PERIOD;
		rst_tb <= '0';

		--16.10 (6 integer bits, 10 fractional bits)
		period_tb <= "0000000000001010"; --close-ish to 10 us
		duty_cycle_tb <= "010000000000"; --Half is duty cycle
		wait for 1100 * CLK_PERIOD;

		rst_tb <= '1';
		wait for CLK_PERIOD;
		rst_tb <= '0';
		
		period_tb <= "0000000000000001"; -- 500 ns;
		duty_cycle_tb <= "000011001100"; --1/10th ish kinda is duty cycle
		wait for 1100 * CLK_PERIOD;

	end process;
end architecture;