library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryBlock is
    generic (
        DATA_WIDTH : integer := 48;
        ADDR_WIDTH : integer := 8
    );
    port(
        clk : in std_logic;
        ce : in std_logic;
        we : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        din : in std_logic_vector(DATA_WIDTH-1 downto 0);
        dout : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end MemoryBlock;

architecture Behavioral of MemoryBlock is
    type ram_type is array (0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    
    attribute ram_style : string;
    attribute ram_style of ram : signal is "block";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if ce = '1' then 
                if we = '1' then
                    ram(to_integer(unsigned(addr))) <= din;
                    dout <= din;
                else
                    dout <= ram(to_integer(unsigned(addr)));
                end if;
            end if; 
         end if;   
    end process;   
end Behavioral;
