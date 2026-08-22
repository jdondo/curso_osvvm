library ieee;
use ieee.std_logic_1164.all;

package ram_pkg is

    constant ADDR_WIDTH : positive := 10;
    constant DATA_WIDTH : positive := 32;

    type ram_operation_t is (
        RAM_READ,
        RAM_WRITE
    );

    type ram_transaction_t is record

        operation : ram_operation_t;

        address   : std_logic_vector(ADDR_WIDTH-1 downto 0);

        data      : std_logic_vector(DATA_WIDTH-1 downto 0);

    end record;

end package;