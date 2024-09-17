library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity one_pulse_tb is
end entity;

architecture testbench of one_pulse_tb is
	component one_pulse is
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			input : in std_ulogic;
			pulse : out std_ulogic
		);
	end component;

	constant CLK_PERIOD : time := 20 ns;

	signal clk_tb, rst_tb, input_tb, pulse_tb : std_ulogic := '0';
begin
	DUT : one_pulse port map (clk => clk_tb, rst => rst_tb, input => input_tb, pulse => pulse_tb);

	clk_tb <= not clk_tb after CLK_PERIOD / 2;

	stimuli_and_checker: process is
	begin
		rst_tb <= '1';
		wait_for_clock_edges(clk_tb, 2);
		rst_tb <= '0';

		input_tb <= '1';
		wait_for_clock_edge(clk_tb);
		input_tb <= '0';
		wait_for_clock_edges(clk_tb, 5);
		input_tb <= '1';
		wait_for_clock_edges(clk_tb, 5);
		input_tb <= '0';
	end process;
end architecture;
