library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library osvvm;
use osvvm.AlertLogPkg.all;
use osvvm.MemoryPkg.all;

use work.ram_pkg.all;
use work.ram_bfm.all;

library std;
use std.env.all;

entity ram_test is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        wr_en : out std_logic;
        rd_en : out std_logic;
        addr  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
        wr_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
        rd_data : in std_logic_vector(DATA_WIDTH-1 downto 0)
    );

end entity;


architecture test of ram_test is
begin
    TestProc : process
        variable MemoryID : MemoryIDType;
        variable expected : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable actual : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable address : std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : std_logic_vector(DATA_WIDTH-1 downto 0);
    begin

        ------------------------------------------------
        -- Create reference memory
        ------------------------------------------------

        MemoryID := NewID(
            Name      => "RAM_REFERENCE",
            AddrWidth => ADDR_WIDTH,
            DataWidth => DATA_WIDTH
        );


        ------------------------------------------------
        -- Wait for reset
        ------------------------------------------------

        wait until reset = '0';
        wait until rising_edge(clk);

        ------------------------------------------------
        -- TEST 1
        -- Write known values
        ------------------------------------------------

        Report("TEST 1: Directed writes");
        for i in 0 to 15 loop

            address := std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            data := std_logic_vector(to_unsigned(i * 16#1111#,DATA_WIDTH));

            -- Write DUT

            RamWrite(
                clk     => clk,
                wr_en   => wr_en,
                rd_en   => rd_en,
                addr    => addr,
                wr_data => wr_data,
                address => address,
                data    => data
            );

            -- Write reference model

            MemWrite(
                MemoryID,
                address,
                data
            );

        end loop;

        ------------------------------------------------
        -- TEST 2
        -- Read and compare
        ------------------------------------------------

        Report("TEST 2: Directed reads");

        for i in 0 to 15 loop
            address := std_logic_vector(to_unsigned(i, ADDR_WIDTH));

            -- Read DUT

            RamRead(
                clk     => clk,
                wr_en   => wr_en,
                rd_en   => rd_en,
                addr    => addr,
                wr_data => wr_data,
                rd_data => rd_data,
                address => address,
                data    => actual
            );

            -- Read reference

            MemRead(
                MemoryID,
                address,
                expected
            );

            -- Compare

            AffirmIfEqual(
                actual,
                expected,
                "RAM read"
            );

        end loop;

        ------------------------------------------------
        -- TEST 3
        -- Write all memory with address pattern
        ------------------------------------------------

        Report("TEST 3: Address pattern");

        for i in 0 to 1023 loop
            address := std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            data := std_logic_vector(to_unsigned(i, DATA_WIDTH));


            RamWrite(
                clk     => clk,
                wr_en   => wr_en,
                rd_en   => rd_en,
                addr    => addr,
                wr_data => wr_data,
                address => address,
                data    => data
            );


            MemWrite(
                MemoryID,
                address,
                data
            );

        end loop;


        ------------------------------------------------
        -- TEST 4
        -- Read all memory
        ------------------------------------------------

        Report("TEST 4: Read entire memory");

        for i in 0 to 1023 loop
            address := std_logic_vector(to_unsigned(i, ADDR_WIDTH));


            RamRead(
                clk     => clk,
                wr_en   => wr_en,
                rd_en   => rd_en,
                addr    => addr,
                wr_data => wr_data,
                rd_data => rd_data,
                address => address,
                data    => actual
            );


            MemRead(
                MemoryID,
                address,
                expected
            );


            AffirmIfEqual(
                actual,
                expected,
                "Full memory check"
            );

        end loop;


        ------------------------------------------------
        -- TEST 5
        -- Random-like deterministic test
        ------------------------------------------------

        Report("TEST 5: Random memory operations");

        for i in 0 to 999 loop
            -- Deterministic pseudo-random address
            address := std_logic_vector(to_unsigned((i * 37) mod 1024, ADDR_WIDTH));

            -- Deterministic pseudo-random data
            data := std_logic_vector(to_unsigned(i * 12345, DATA_WIDTH));

            if (i mod 2) = 0 then
                ------------------------------------------------
                -- WRITE
                ------------------------------------------------
                RamWrite(
                    clk     => clk,
                    wr_en   => wr_en,
                    rd_en   => rd_en,
                    addr    => addr,
                    wr_data => wr_data,
                    address => address,
                    data    => data
                );

                MemWrite(
                    MemoryID,
                    address,
                    data
                );
            else
                ------------------------------------------------
                -- READ
                ------------------------------------------------
                RamRead(
                    clk     => clk,
                    wr_en   => wr_en,
                    rd_en   => rd_en,
                    addr    => addr,
                    wr_data => wr_data,
                    rd_data => rd_data,
                    address => address,
                    data    => actual
                );


                MemRead(
                    MemoryID,
                    address,
                    expected
                );


                AffirmIfEqual(
                    actual,
                    expected,
                    "Random memory check"
                );

            end if;

        end loop;


        ------------------------------------------------
        -- TEST COMPLETE
        ------------------------------------------------

        Report("======================================");
        Report("RAM TEST COMPLETE");
        Report("======================================");
        ReportAlerts;
        stop;
    end process;

end architecture;
