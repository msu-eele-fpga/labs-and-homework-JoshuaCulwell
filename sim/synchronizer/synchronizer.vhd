library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
    port (
        clk   : in  std_ulogic;
        async : in  std_ulogic;
        sync  : out std_ulogic
    );
end entity;

architecture synchronizer_arch of synchronizer is

signal D1, D2 : std_ulogic := '0';
signal Q1, Q2 : std_ulogic := '0';

begin
    D1 <= async;
    D2 <= Q1;
    sync <= Q2;
    process(clk, async)
        begin
            if (rising_edge(clk)) then 
                Q1 <= D1;
                Q2 <= D2;
            end if;
    end process;
end architecture;
