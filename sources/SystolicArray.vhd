library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.types_pkg.ALL;

entity SystolicArray is
    generic (
        N : integer := 35
    );
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        we : in std_logic;
        valid_in : in std_logic;
        A_in : in std_logic_vector(15 downto 0);
        B_in : in std_logic_vector(15 downto 0);
        done: out std_logic;
        C_result : out std_logic_vector(47 downto 0)   
    );    
end SystolicArray;

architecture Behavioral of SystolicArray is  
    signal valid_a : sl_matrix(0 to N-1, 0 to N-1);
    signal valid_b : sl_matrix(0 to N-1, 0 to N-1);
    signal valid_pe : sl_matrix(0 to N-1, 0 to N-1);

    signal a_left_reg : slv16_array(0 to N-1);
    signal b_top_reg : slv16_array(0 to N-1);

    signal a_sig : slv_matrix(0 to N-1, 0 to N-1)(15 downto 0);
    signal b_sig : slv_matrix(0 to N-1, 0 to N-1)(15 downto 0);  
       
    signal a_sig_out : slv_matrix(0 to N-1, 0 to N-1)(15 downto 0);
    signal b_sig_out : slv_matrix(0 to N-1, 0 to N-1)(15 downto 0);   
    signal c_sig_out : slv_matrix(0 to N-1, 0 to N-1)(47 downto 0);   
    
    signal c_raw : std_logic_vector(47 downto 0);   
    signal c_reg : std_logic_vector(47 downto 0);   
    
    signal i_cnt : integer range 0 to N-1 := 0;
    signal j_cnt : integer range 0 to N-1 := 0;
    
    signal addr_sig : std_logic_vector(7 downto 0);  
    signal din_sig : std_logic_vector(47 downto 0);  
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for i in 0 to N-1 loop
                    a_left_reg(i) <= (others => '0');
                    b_top_reg(i) <= (others => '0');
                end loop;
            elsif ce = '1' and valid_in = '1' then
                a_left_reg(0) <= A_in;
                b_top_reg(0) <= B_in;
                for i in 1 to N-1 loop
                    a_left_reg(i) <= a_left_reg(i-1);
                    b_top_reg(i) <= b_top_reg(i-1);
                end loop;                
            end if;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                c_reg <= (others => '0');
            elsif ce = '1' then
                c_reg <= c_raw;
            end if;
        end if;
    end process;
    
    GEN_LEFT_VALID : for i in 0 to N-1 generate
        valid_a(i,0) <= valid_in;
    end generate;
    
    GEN_TOP_VALID : for i in 0 to N-1 generate
        valid_b(0,i) <= valid_in;
    end generate;      
    
    GEN_LEFT_A : for i in 0 to N-1 generate
        a_sig(i,0) <= a_left_reg(i);
    end generate;
    
    GEN_TOP_B : for i in 0 to N-1 generate
        b_sig(0,i) <= b_top_reg(i);
    end generate;    
    
    GEN_ROWS : for i in 0 to N-1 generate
        GEN_COLUMNS : for j in 0 to N-1 generate
                GEN_LEFT_A : if (j > 0) generate
                    process(clk)
                    begin
                        if rising_edge(clk) then
                            if rst = '1' then
                                a_sig(i,j) <= (others => '0');
                                valid_a(i,j) <= '0';
                            elsif ce = '1' then
                                a_sig(i,j) <= a_sig_out(i,j-1);
                                valid_a(i,j) <= valid_a(i,j-1);
                            end if;    
                        end if;
                    end process;
                end generate;
    
                GEN_TOP_B : if (i > 0) generate
                    process(clk)
                    begin
                        if rising_edge(clk) then 
                            if rst = '1' then
                                b_sig(i,j) <= (others => '0');
                                valid_b(i,j) <= '0';
                            elsif ce = '1' then
                                b_sig(i,j) <= b_sig_out(i-1,j);
                                valid_b(i,j) <= valid_b(i-1,j);
                            end if;    
                        end if;
                    end process;                    
                end generate;      
                
                valid_pe(i,j) <= valid_a(i,j) and valid_b(i,j);
                
                PE_inst : entity work.PE
                    port map(
                        clk => clk,
                        rst => rst,
                        ce => ce,
                        valid_in => valid_pe(i,j),
                        a_in => a_sig(i,j),
                        b_in => b_sig(i,j),
                        a_out => a_sig_out(i,j),
                        b_out => b_sig_out(i,j),
                        c_out => c_sig_out(i,j)  
                    );        
        end generate;
    end generate;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if ce = '1' and we = '1' then
                din_sig <= c_sig_out(i_cnt,j_cnt); 
                addr_sig <= std_logic_vector(to_unsigned(i_cnt*N + j_cnt, 8));
                if j_cnt = N-1 then
                    j_cnt <= 0;
                    if i_cnt = N-1 then
                        i_cnt <= 0;
                    else
                        i_cnt <= i_cnt + 1;
                    end if;
                else
                    j_cnt <= j_cnt + 1;
                end if;         
            end if;
        end if;    
    end process;    
        
    MemoryBlock_inst : entity work.MemoryBlock
       port map(
          clk => clk,
          ce => ce,
          we => we,
          addr => addr_sig,
          din => din_sig,
          dout => c_raw
       );
   
   done <= '1' when (i_cnt=N-1 and j_cnt=N-1) else '0';       
   C_result <= c_reg;       
     
end Behavioral;
