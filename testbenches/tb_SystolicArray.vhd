library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_SystolicArray is
end tb_SystolicArray;

architecture Behavioral of tb_SystolicArray is
    constant CLK_PERIOD : time := 5 ns;
    constant N : integer := 35;
    
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0';
    signal we : std_logic := '0';
    signal valid_in : std_logic;
    signal A_in : std_logic_vector(15 downto 0) := (others => '0');
    signal B_in : std_logic_vector(15 downto 0) := (others => '0');
    signal done : std_logic;
    signal C_result : std_logic_vector(47 downto 0);       
begin

    uut : entity work.SystolicArray
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            we => we,
            valid_in => valid_in,
            A_in => A_in,
            B_in => B_in,
            done => done,
            C_result => C_result 
        );
    
    clock_process : process
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
        rst <= '1';
        valid_in <= '0';
        ce <= '0';
        we <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        ce <= '1';
        we <= '1';
        
        for k in 0 to (N*N-1) loop
            valid_in <= '1';
            A_in <= std_logic_vector(to_signed(k+1,16));
            B_in <= std_logic_vector(to_signed(1,16));
            wait until rising_edge(clk);
        end loop;
        
        valid_in <= '0';
        
        wait until done = '1';
        
        wait;
    end process;
end Behavioral;
