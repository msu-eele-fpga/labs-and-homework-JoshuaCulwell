library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_patterns is
	generic (
		system_clock_period : time := 20 ns
	);
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		push_button : in std_ulogic;
		switches : in std_ulogic_vector(3 downto 0);
		hps_led_control : in boolean;
		base_period : in unsigned(7 downto 0);
		led_reg : in std_ulogic_vector(7 downto 0);
		led : out std_ulogic_vector(7 downto 0)
	);
end entity;

architecture led_patterns_arch of led_patterns is
	component async_conditioner is
		port (
			clk : in std_ulogic;
			rst : in std_ulogic;
			async : in std_ulogic;
			sync : out std_ulogic
		);
	end component;
	
	type state_type is (s0, s1, s2, s3, s4, arm, disp_sw);
	signal current_state, next_state : state_type := s0;
	constant one_second : unsigned(38 downto 0) := to_unsigned(1 sec / system_clock_period, 39);
	
	signal one_base_period : unsigned(38 downto 0);
	
	signal count, count_led7 : unsigned(38 downto 0) := to_unsigned(1, 39);
	signal counter_limit : unsigned(38 downto 0);
	signal done, done_disp_sw, done_led7 : boolean := false;
	
	signal state_counter : unsigned(6 downto 0) := "0000000";
	signal state_4_counter : unsigned(8 downto 0) := "000000001";
	signal led_output_1 : std_ulogic_vector(6 downto 0) := "0000001";
	signal led_output_2 : std_ulogic_vector(6 downto 0) := "0000011";
	signal led_7_output : std_ulogic;
	
	signal pulse : std_ulogic := '0';
	
	signal lab_5_clock_div : std_ulogic := '0';
	signal lab_5_count : unsigned(38 downto 0) := to_unsigned(1, 39);
	
begin
	one_base_period <= to_unsigned((1 sec / system_clock_period) / 16, 31) * base_period;

	conditioner : async_conditioner port map(clk => clk, rst => rst, async => push_button, sync => pulse);
	
	LAB_5_CLOCK : process(clk, rst)
	begin
		if (rst = '1') then
			lab_5_count <= to_unsigned(0, 39);
			
		elsif (rising_edge(clk)) then
			if (lab_5_count < one_base_period / 16) then
				lab_5_count <= lab_5_count + 1;
			elsif (lab_5_count >= one_base_period / 16) then
				lab_5_clock_div <= not lab_5_clock_div;
			end if;
		end if;
	end process;
	
	COUNTER_STATES : process (clk, rst)
	begin
		if (rst = '1') then
			count <= to_unsigned(1, 39);
			done <= false;
		elsif (rising_edge(clk) and count < counter_limit) then
			count <= count + 1;
			done <= false;
		elsif (rising_edge(clk) and count >= counter_limit) then
			count <= to_unsigned(1, 39);
			done <= true;
		end if;
	end process;
	
	COUNTER_LED7 : process (clk, rst)
	begin
		if (rst = '1') then
			count_led7 <= to_unsigned(1, 39);
			done_led7 <= false;
		elsif (rising_edge(clk) and count_led7 < one_base_period) then
			count_led7 <= count_led7 + 1;
			done_led7 <= false;
		elsif (rising_edge(clk) and count_led7 >= one_base_period) then
			count_led7 <= to_unsigned(1, 39);
			done_led7 <= true;
		end if;
	end process;
	
	STATE_MEMORY : process (clk, rst)
	begin
		if (rising_edge(clk)) then current_state <= next_state;
		end if;
	end process;
	
	NEXT_STATE_LOGIC : process (current_state, pulse, rst, done_disp_sw)
	begin
		if(rst = '1') then
			next_state <= s0;
		elsif (hps_led_control) then next_state <= arm;
		elsif (pulse = '1') then
			next_state <= disp_sw;
		elsif (done_disp_sw = true) then
			case (switches) is
				when "0000" => next_state <= s0;
				when "0001" => next_state <= s1;
				when "0010" => next_state <= s2;
				when "0011" => next_state <= s3;
				when "0100" => next_state <= s4;
				when others => next_state <= current_state;
			end case;
		end if;
	end process;
	
	OUTPUT_LOGIC : process (rst, clk, current_state, done)
	begin
		if(rising_edge(clk)) then
			case (current_state) is
				when disp_sw =>
					counter_limit <= one_second; --one second
					
					if (done) then done_disp_sw <= true;
					else done_disp_sw <= false;
					end if;
					
					led(6 downto 0) <= "000" & switches;
				when s0 => 
					counter_limit <= one_base_period / 2; -- 1/2 base period
					
					if (rst = '1') then led_output_1 <= "0000001";
					elsif (done) then
						led_output_1 <= led_output_1(0) & led_output_1(6 downto 1);
					end if;
					
					led(6 downto 0) <= led_output_1;
				when s1 =>
					counter_limit <= one_base_period / 4; -- 1/4 base period
					
					if (rst = '1') then led_output_2 <= "0000011";
					elsif (done) then
						led_output_2 <= led_output_2(5 downto 0) & led_output_2(6);
					end if;
					
					led(6 downto 0) <= led_output_2;
				when s2 =>
					counter_limit <= one_base_period(36 downto 0) * to_unsigned(2, 2); -- 2 base period
					
					if (rst = '1') then state_counter <= to_unsigned(0, 7);
					elsif (done and state_counter < 127) then state_counter <= state_counter + 1;
					elsif (done and state_counter >= 127) then state_counter <= to_unsigned(0, 7);
					end if;
					
					led(6 downto 0) <= std_ulogic_vector(state_counter);
				when s3 =>
					counter_limit <= one_base_period / 8; -- 1/8 base period
				
					if (rst = '1') then state_counter <= to_unsigned(0, 7);
					elsif (done and state_counter > 0) then state_counter <= state_counter - 1;
					elsif (done and state_counter <= 0) then state_counter <= to_unsigned(127, 7);
					end if;
					
					led(6 downto 0) <= std_ulogic_vector(state_counter);
				when s4 =>
					counter_limit <= one_base_period / 16; -- 1/16 base period
					
					if (rst = '1') then state_4_counter <= to_unsigned(1, 9);
					elsif (done and state_4_counter < 127) then state_4_counter <= state_4_counter(6 downto 0) * to_unsigned(3, 2);
					elsif (done and state_4_counter >= 127) then state_4_counter <= to_unsigned(1, 9);
					end if;
					
					led(6 downto 0) <= std_ulogic_vector(state_4_counter(6 downto 0));				
				when arm => led <= led_reg;
			end case;
			
			if done_led7 then led_7_output <= not led_7_output;
			end if;
		end if;
		
		led(7) <= lab_5_clock_div; --led_7_output;
	end process;	
end architecture;