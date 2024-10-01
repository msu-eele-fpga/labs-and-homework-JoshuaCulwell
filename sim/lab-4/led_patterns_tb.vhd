library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity led_patterns_tb is
end entity;

architecture testbench of led_patterns_tb is
	component led_patterns is
		generic (
			system_clock_period: time := 20 ns
		);
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			push_button : in std_ulogic;
			switches : in std_ulogic_vector(3 downto 0);
			hps_led_control : in boolean;
			base_period : unsigned(7 downto 0);
			led_reg : in std_ulogic_vector(7 downto 0);
			led : out std_ulogic_vector(7 downto 0)
		);
	end component;

	signal clk_tb : std_ulogic := '0';
	signal rst_tb, push_button_tb : std_ulogic;
	signal switches_tb : std_ulogic_vector(3 downto 0);
	signal hps_led_control_tb : boolean := false;
	signal base_period_tb : unsigned(7 downto 0) := "00010000";
	signal led_reg_tb, led_tb : std_ulogic_vector(7 downto 0);

	signal switch_stim : unsigned(3 downto 0) := to_unsigned(0, 4);

begin

	DUT : led_patterns generic map (system_clock_period => 1 ms)
			   port map (clk => clk_tb, rst => rst_tb, push_button => push_button_tb, switches => switches_tb, hps_led_control => hps_led_control_tb, base_period => base_period_tb, led_reg => led_reg_tb, led => led_tb);

	CLOCK : process
	begin
		clk_tb <= not clk_tb;
		wait for 1 ns;
	end process;

	STIM : process
	begin
		rst_tb <= '1';
		wait_for_clock_edges(clk_tb, 2);
		rst_tb <= '0';
		wait_for_clock_edge(clk_tb);

		for i in 0 to 6 loop
			switches_tb <= std_ulogic_vector(switch_stim);
			push_button_tb <= '1';
			wait_for_clock_edges(clk_tb, 5);
			push_button_tb <= '0';
			wait_for_clock_edges(clk_tb, 5000);

			switch_stim <= switch_stim + 1;
		end loop;
	end process;
end architecture;
