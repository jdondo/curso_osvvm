library ieee;
use ieee.std_logic_1164.all;
use work.ram_pkg.all;

package ram_bfm is
    procedure RamWrite(
        signal clk     : in  std_logic;
        signal wr_en   : out std_logic;
        signal rd_en   : out std_logic;
        signal addr    : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        signal wr_data : out std_logic_vector(DATA_WIDTH-1 downto 0);

        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        constant data    : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );


    procedure RamRead(
        signal clk     : in  std_logic;
        signal wr_en   : out std_logic;
        signal rd_en   : out std_logic;
        signal addr    : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        signal wr_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
        signal rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );

end package;


package body ram_bfm is

    procedure RamWrite(
        signal clk     : in  std_logic;
        signal wr_en   : out std_logic;
        signal rd_en   : out std_logic;
        signal addr    : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        signal wr_data : out std_logic_vector(DATA_WIDTH-1 downto 0);

        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        constant data    : in std_logic_vector(DATA_WIDTH-1 downto 0)
    ) is

    begin

        wait until falling_edge(clk);
        addr    <= address;
        wr_data <= data;
        wr_en <= '1';
        rd_en <= '0';

        wait until rising_edge(clk);
        wr_en <= '0';

    end procedure;


    procedure RamRead(
        signal clk     : in  std_logic;
        signal wr_en   : out std_logic;
        signal rd_en   : out std_logic;
        signal addr    : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        signal wr_data : out std_logic_vector(DATA_WIDTH-1 downto 0);

        signal rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    ) is

    begin

        wait until falling_edge(clk);
        addr <= address;
        wr_en <= '0';
        rd_en <= '1';

        wait until rising_edge(clk);
         wait for 0 ns;
        data := rd_data;
        rd_en <= '0';

    end procedure;

end package body;
