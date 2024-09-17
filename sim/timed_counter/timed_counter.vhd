library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timed_counter is
	generic (
		clk_period : time;
		count_time : time
	);
	port (
		clk : in std_ulogic;
		enable : in boolean;
		done : out boolean
	);
end entity timed_counter;

architecture timed_counter_arch of timed_counter is
	constant COUNTER_LIMIT: integer := count_time / clk_period;

	signal count : integer range -1 to 1000 := 0;

begin
	process(clk)
	begin
		if(enable = true and rising_edge(clk)) then
			if(count /= COUNTER_LIMIT) then
				count <= count + 1;
			elsif(count = COUNTER_LIMIT) then
				count <= 0;
				done <= true;
			end if;
		end if;

		if(rising_edge(clk) and count /= COUNTER_LIMIT) then
			done <= false;
		end if;
	end process;
end architecture;

