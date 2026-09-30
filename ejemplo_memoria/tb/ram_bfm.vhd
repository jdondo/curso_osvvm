library ieee;
use ieee.std_logic_1164.all;

use work.ram_pkg.all;




package ram_bfm_pkg is

type ram_bfm is record
    rd_en : std_logic;
    wr_en : std_logic;
    addr  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    wr_data : std_logic_vector (DATA_WIDTH-1 downto 0);

end record ram_bfm;

    constant RAM_BFM_INIT : ram_bfm := (
        rd_en   => '0',
        wr_en   => '0',
        addr    => (others => '0'),
        wr_data => (others => '0')
    );

    procedure RamWrite(
        signal tr_rec : inout ram_bfm;
        signal clk     : in  std_logic;
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        constant data    : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );


    procedure RamRead(
        signal tr_rec : inout ram_bfm;
        signal clk     : in  std_logic;
        signal   rd_data : in    std_logic_vector(DATA_WIDTH-1 downto 0);
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );

end package;


package body ram_bfm_pkg is

    procedure RamWrite(
        signal tr_rec : inout ram_bfm;
        signal clk     : in  std_logic;
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        constant data    : in std_logic_vector(DATA_WIDTH-1 downto 0)
    ) is

    begin

        wait until rising_edge(clk);
        tr_rec.addr    <= address;
        tr_rec.wr_data <= data;
        tr_rec.wr_en <= '1';
        tr_rec.rd_en <= '0';

        wait until rising_edge(clk);
        tr_rec.wr_en <= '0';

    end procedure;


    procedure RamRead(
        signal tr_rec: inout ram_bfm;
        signal clk     : in  std_logic;
        signal rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
        constant address : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : out std_logic_vector(DATA_WIDTH-1 downto 0)
    ) is

    begin

        wait until rising_edge(clk);
        tr_rec.addr <= address;
        tr_rec.wr_en <= '0';
        tr_rec.rd_en <= '1';

        wait until rising_edge(clk);
        tr_rec.rd_en <= '0';
        wait until rising_edge(clk);
        data:= rd_data;



    end procedure;

end package body;
