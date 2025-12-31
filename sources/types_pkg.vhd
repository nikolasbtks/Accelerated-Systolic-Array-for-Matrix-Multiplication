library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types_pkg is
    type slv16_array is array (natural range <>) of std_logic_vector(15 downto 0);
    type slv48_array is array (natural range <>) of std_logic_vector(47 downto 0);
    type sl_matrix is array (natural range <>, natural range <>) of std_logic;
    type slv_matrix is array (natural range <>,natural range <>) of std_logic_vector;
end package types_pkg;