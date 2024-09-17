library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
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
end entity debouncer;

architecture debouncer_arch of debouncer is
	constant COUNTER_LIMIT: integer := (debounce_time / clk_period) - 1;
	signal count : integer range 0 to 1024 := 1;
	signal enable_counter : boolean := false;
	signal done : boolean := false;

	type state_type is (s0, s1, s2, s3);
	signal current_state, next_state : state_type := s0;
	
begin

	COUNTER : process (clk, enable_counter)
	begin
		if (enable_counter and rising_edge(clk) and count < COUNTER_LIMIT) then
			count <= count + 1;
			done <= false;
		elsif (count >= COUNTER_LIMIT and rising_edge(clk)) then
			count <= 1;
			done <= true;
		elsif (enable_counter = false) then count <= 1;
		end if;
	end process;
			
	STATE_MEMORY : process (clk, rst, input)
	begin
		if(rst = '1') then current_state <= s0;
		elsif (rising_edge(clk)) then current_state <= next_state;
		end if;
	end process;

	NEXT_STATE_LOGIC : process (current_state, input, done)
	begin
		case (current_state) is
			when s0 => 	if(input = '1') then next_state <= s1;
					else next_state <= s0;
					end if;
			when s1 =>	if(done and input /= '1') then next_state <= s3;
					elsif(done) then next_state <= s2;
					end if;
			when s2 =>      if(input /= '1') then next_state <= s3;
					else next_state <= s2;
					end if;
			when s3 => 	if(done) then next_state <= s0;
					else next_state <= s3;
					end if;
		end case;
	end process;
	
	OUTPUT_LOGIC : process (current_state)
	begin
		case (current_state) is
			when s0 => 
				enable_counter <= false;
				debounced <= '0';
			when s1 => 
				enable_counter <= true;
				debounced <= '1';
			when s2 => 
				enable_counter <= false;
				debounced <= '1';
			when s3 =>
				enable_counter <= true;
				debounced <= '0';
		end case;
	end process;
end architecture;
