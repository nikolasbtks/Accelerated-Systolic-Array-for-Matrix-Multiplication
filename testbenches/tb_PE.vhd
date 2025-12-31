library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_PE is
end tb_PE;

architecture Behavioral of tb_PE is
    constant CLK_PERIOD : time := 10 ns;
       
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ce : std_logic := '0';
    
    signal valid_in : std_logic := '0';    
    signal a_in : std_logic_vector(15 downto 0) := (others => '0');
    signal b_in : std_logic_vector(15 downto 0) := (others => '0');

    signal a_out : std_logic_vector(15 downto 0);
    signal b_out : std_logic_vector(15 downto 0);
    signal c_out : std_logic_vector(47 downto 0);   
begin
    uut : entity work.PE
        port map(
            clk => clk,
            rst => rst,
            ce => ce,
            valid_in => valid_in,
            a_in => a_in,
            b_in => b_in,
            a_out => a_out,
            b_out => b_out,
            c_out => c_out
        );
        
     clk_process : process
     begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
     end process;   
     
     stimulus : process
     begin
        valid_in <= '0';
        ce <= '0'; 
        valid_in <= '0';
        wait until rising_edge(clk);
        rst <= '0';
        ce <= '1';  
        
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(2,16));
        b_in <= std_logic_vector(to_signed(4,16)); 
        wait until rising_edge(clk);
        
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(4,16));
        b_in <= std_logic_vector(to_signed(4,16)); 
        wait until rising_edge(clk);  
        
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(5,16));
        b_in <= std_logic_vector(to_signed(5,16)); 
        wait until rising_edge(clk); 
 
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(6,16));
        b_in <= std_logic_vector(to_signed(6,16)); 
        wait until rising_edge(clk);
 
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(2,16));
        b_in <= std_logic_vector(to_signed(2,16)); 
        wait until rising_edge(clk);           
        
        valid_in <= '1';
        a_in <= std_logic_vector(to_signed(1,16));
        b_in <= std_logic_vector(to_signed(1,16)); 
        wait until rising_edge(clk);              
        valid_in <= '0';
        wait;
     end process;
     
end Behavioral;