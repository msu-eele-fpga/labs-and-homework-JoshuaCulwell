library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns_avalon is
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		-- avalon memory-mapped slave interface
		avs_read : in std_logic;
		avs_write : in std_logic;
		avs_address : in std_logic_vector(1 downto 0);
		avs_readdata : out std_logic_vector(31 downto 0);
		avs_writedata : in std_logic_vector(31 downto 0);
		-- external I/O; export to top-level
		push_button : in std_ulogic;
		switches : in std_ulogic_vector(3 downto 0);
		led : out std_ulogic_vector(7 downto 0)
	);
end entity led_patterns_avalon;		

architecture led_patterns_avalon_arch of led_patterns_avalon is

	component led_patterns is
		generic (
			system_clock_period : time := 20 ns
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
	
	signal led_reg : std_ulogic_vector(7 downto 0);
	signal base_period : unsigned(7 downto 0);
	signal hps_led_control : std_ulogic := '0';
	signal hps_led_control_bool : boolean := false;

begin
	LED_PATTERN_COMPONENT : led_patterns
		generic map (system_clock_period => 20 ns)
		port map (clk => clk, rst => rst, push_button => not push_button, switches => switches, hps_led_control => hps_led_control_bool, base_period => base_period, led_reg => led_reg, std_logic_vector(led) => led);
	
	process (hps_led_control)
	begin
		if hps_led_control = '1' then hps_led_control_bool <= true;
		else hps_led_control_bool <= false;
		end if;
	end process;
	
	avalon_register_read: process(clk)
	begin
		if rising_edge(clk) and avs_read = '1' then
			case avs_address is
				when "00" => 
					avs_readdata <= (others => '0');
					avs_readdata(7 downto 0) <= std_logic_vector(base_period);
				when "01" =>
					avs_readdata <= (others => '0');
					avs_readdata(7 downto 0) <= std_logic_vector(led_reg);
				when "10" => 
					avs_readdata <= (others => '0');
					avs_readdata(0) <= std_logic(hps_led_control);
				when others => avs_readdata <= (others => '0');
			end case;
		end if;
	end process;
	
	avalon_register_write : process(clk, rst)
	begin
		if rst = '1' then
			base_period <= "00010000";
			led_reg <= "00000000";
			hps_led_control <= '0';
		elsif rising_edge(clk) and avs_write = '1' then
			case avs_address is
				when "00" => base_period <= unsigned(avs_writedata(7 downto 0));
				when "01" => led_reg <= std_ulogic_vector(avs_writedata(7 downto 0));
				when "10" => hps_led_control <= avs_writedata(0);
				when others => null;
			end case;
		end if;
	end process;

end architecture;