library ieee;
use ieee.std_logic_1164.all;

entity ram_tb is

end entity;


architecture sim of ram_tb is

    constant ADDR_WIDTH : positive := 10;
    constant DATA_WIDTH : positive := 32;
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal wr_en : std_logic;
    signal rd_en : std_logic;
    signal addr :  std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal wr_data :  std_logic_vector(DATA_WIDTH-1 downto 0);
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

            wr_en   => wr_en,

            rd_en   => rd_en,

            addr    => addr,

            wr_data => wr_data,

            rd_data => rd_data

        );


    ------------------------------------------------
    -- TEST
    ------------------------------------------------

    TEST : entity work.ram_test

        port map (

            clk     => clk,

            reset   => reset,

            wr_en   => wr_en,

            rd_en   => rd_en,

            addr    => addr,

            wr_data => wr_data,

            rd_data => rd_data

        );


end architecture;
