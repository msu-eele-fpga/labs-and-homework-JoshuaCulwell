library ieee;
use ieee.std_logic_1164.all;

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

	signal count : integer range 0 to 1000;

begin
	process(clk)
		if(enable = true) then
			if(rising_edge(clk) and count /= COUNTER_LIMIT) then
				count = counter + 1;
			end if;
		end if;
	end process;

	process(clk)
		if(count = COUNTER_LIMIT) then
			done <= true;
		else
			done <= false;
		end if;
	end process;
end architecture;

