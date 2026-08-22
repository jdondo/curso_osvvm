library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    generic (
        ADDR_WIDTH : positive := 10;
        DATA_WIDTH : positive := 32
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;

        wr_en   : in  std_logic;
        rd_en   : in  std_logic;

        addr    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
        wr_data : in  std_logic_vector(DATA_WIDTH-1 downto 0);

        rd_data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;


architecture rtl of ram is

    type ram_type is array (
        0 to 2**ADDR_WIDTH-1
    ) of std_logic_vector(DATA_WIDTH-1 downto 0);

    signal mem : ram_type;

begin

    process(clk)
        variable addr_int : integer;
    begin

        if rising_edge(clk) then
            if reset = '1' then
                rd_data <= (others => '0');
            else
                addr_int := to_integer(unsigned(addr));
                if wr_en = '1' then
                    mem(addr_int) <= wr_data;
                end if;
                if rd_en = '1' then
                    rd_data <= mem(addr_int);
                end if;
            end if;
        end if;

    end process;

end architecture;
