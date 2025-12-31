library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MemoryBlock is
end tb_MemoryBlock;

architecture Behavioral of tb_MemoryBlock is
        constant CLK_PERIOD : time := 10 ns;
        
        signal clk : std_logic := '0';
        signal ce : std_logic := '1';
        
        signal we : std_logic := '0';
        signal addr : std_logic_vector(7 downto 0);
        signal din : std_logic_vector(47 downto 0);
        signal dout : std_logic_vector(47 downto 0);
begin
    uut : entity work.MemoryBlock
        port map(
            clk => clk,
            ce => ce,
            we => we,
            addr => addr,
            din => din,
            dout => dout
        );

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    stimulus : process
    begin
        wait until rising_edge(clk);
        
        we <= '1';
        addr <= x"01";
        din <= std_logic_vector(to_unsigned(5,48));
        wait until rising_edge(clk);
        we <= '1';
        addr <= x"02";
        din <= std_logic_vector(to_unsigned(10,48));
        wait until rising_edge(clk);        
        we <= '0';        
        wait until rising_edge(clk);

        addr <= x"01";
        wait until rising_edge(clk);       
       
        wait;
    end process;
end Behavioral;
