library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PE is
    port(
        clk : in std_logic;
        rst : in std_logic;
        ce : in std_logic;
        
        valid_in : in std_logic;
        a_in : in std_logic_vector(15 downto 0);
        b_in : in std_logic_vector(15 downto 0);

        a_out : out std_logic_vector(15 downto 0);
        b_out : out std_logic_vector(15 downto 0);
        c_out : out std_logic_vector(47 downto 0)        
    );
end PE;

architecture Behavioral of PE is
    component dsp_macro_0 is
        port(
            CLK : in std_logic;
            A : in std_logic_vector(15 downto 0);
            B : in std_logic_vector(15 downto 0);
            P : out std_logic_vector(47 downto 0);
            CEA3 : in std_logic;
            CEA4 : in std_logic;
            CEB3 : in std_logic;
            CEB4 : in std_logic;
            CEP : in std_logic
        );
    end component;
    
    signal a_reg : std_logic_vector(15 downto 0);
    signal b_reg : std_logic_vector(15 downto 0);
    
    signal p_raw : std_logic_vector(47 downto 0);
    signal p_reg : std_logic_vector(47 downto 0);
    
    signal valid_pipe : std_logic_vector(4 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                a_reg <= (others => '0');
                b_reg <= (others => '0');
                p_reg <= (others => '0');
                valid_pipe <= (others => '0');
            elsif ce = '1' then 
                valid_pipe <= valid_pipe(3 downto 0) & valid_in;
                --if valid_in = '1' then
                a_reg <= a_in;
                b_reg <= b_in;
                --end if;
            end if;    
            if valid_pipe(4) = '1' then
                p_reg <= p_raw;
            end if;
        end if;
    end process;
    
    DSP_inst : dsp_macro_0
        port map(
            CLK => clk,
            A => a_reg,
            B => b_reg,
            P => p_raw,
            CEA3 => ce,
            CEA4 => ce,
            CEB3 => ce,
            CEB4 => ce,
            CEP => ce
      );

    a_out <= a_reg;
    b_out <= b_reg;
    c_out <= p_reg;
end Behavioral;
