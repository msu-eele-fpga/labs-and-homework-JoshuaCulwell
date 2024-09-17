library ieee;
use ieee.std_logic_1164.all;

entity one_pulse is
	port (
		clk : in std_ulogic;
		rst : in std_ulogic;
		input: in std_ulogic;
		pulse: out std_ulogic
	);
end entity;

architecture one_pulse_arch of one_pulse is
	signal pulsed : boolean := false;
begin
	process(clk, rst)
	begin
		if(rst = '1') then 
			pulse <= '0';
			pulsed <= false;
		elsif(rising_edge(clk) and input = '1' and not pulsed) then
			pulse <= '1';
			pulsed <= true;
		elsif(rising_edge(clk) and input = '1' and pulsed) then
			pulse <= '0';
		elsif(rising_edge(clk) and input = '0') then
			pulse <= '0';
			pulsed <= false;
		end if;
	end process;
end architecture;
			