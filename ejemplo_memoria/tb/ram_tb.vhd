library ieee;
use ieee.std_logic_1164.all;
use work.ram_pkg.all;
use work.ram_bfm_pkg.all;
entity ram_tb is

end entity;


architecture sim of ram_tb is

    signal tr_rec : ram_bfm :=RAM_BFM_INIT;
    constant ADDR_WIDTH : positive := 10;
    constant DATA_WIDTH : positive := 32;
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal rd_data :  std_logic_vector(DATA_WIDTH-1 downto 0);

begin


    ------------------------------------------------
    -- Clock
    ------------------------------------------------

    clk <= not clk after 5 ns;


    ------------------------------------------------
    -- Reset
    ------------------------------------------------

    reset_process : process
    begin

        reset <= '1';

        wait for 50 ns;

        reset <= '0';

        wait;

    end process;


    ------------------------------------------------
    -- DUT
    ------------------------------------------------

    DUT : entity work.ram

        generic map (

            ADDR_WIDTH => ADDR_WIDTH,

            DATA_WIDTH => DATA_WIDTH

        )

        port map (

            clk     => clk,

            reset   => reset,

            wr_en   => tr_rec.wr_en,

            rd_en   => tr_rec.rd_en,

            addr    => tr_rec.addr,

            wr_data => tr_rec.wr_data,

            rd_data => rd_data

        );


    ------------------------------------------------
    -- TEST
    ------------------------------------------------

    TEST : entity work.ram_test

        port map (

            tr_rec => tr_rec,
            clk     => clk,

            reset   => reset,

            rd_data => rd_data

        );


end architecture;
