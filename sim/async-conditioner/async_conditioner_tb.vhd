library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity async_conditioner_tb is
end entity;

architecture testbench of async_conditioner_tb is
	component async_conditioner is
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			async : in std_ulogic;
			sync : out std_ulogic
		);
	end component;

	constant CLK_PERIOD : time := 20 ns;
	constant DEBOUNCE_TIME : time := 100 ns;

	signal clk_tb, rst_tb, async_tb, sync_tb : std_ulogic := '0';
begin
	DUT : async_conditioner port map (clk => clk_tb, rst => rst_tb, async => async_tb, sync => sync_tb);

	clk_tb <= not clk_tb after CLK_PERIOD / 2;

	stimuli_and_checker: process is
	begin
		rst_tb <= '1';
		wait_for_clock_edges(clk_tb, 2);
		rst_tb <= '0';

		async_tb <= '1';
		wait_for_clock_edges(clk_tb, 2);
		async_tb <= '0';

		wait_for_clock_edges(clk_tb, (DEBOUNCE_TIME / CLK_PERIOD) + 2);

		async_tb <= '1';
		wait_for_clock_edges(clk_tb, 5);
		async_tb <= '0';

		wait_for_clock_edges(clk_tb, 10);
	end process;
end architecture;
