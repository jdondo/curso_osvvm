library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library osvvm;

use osvvm.AlertLogPkg.all;
use osvvm.MemoryPkg.all;
use osvvm.CoveragePkg.all;
use osvvm.RandomPkg.all;

use work.ram_pkg.all;
use work.ram_bfm_pkg.all;

library std;
use std.env.all;

entity ram_test is

    port (
        tr_rec :  inout ram_bfm;
        clk   : in std_logic;
        reset : in std_logic;

         rd_data :  in std_logic_vector(DATA_WIDTH-1 downto 0)

    );

end entity;


architecture test of ram_test is
       signal actual : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

    TestProc : process

        variable MemoryID : MemoryIDType;    --proviene de MemoryGenericPkg.vhd llamado por MemoryPkg
        variable expected : std_logic_vector(DATA_WIDTH-1 downto 0);
        variable actual : std_logic_vector(DATA_WIDTH-1 downto 0);

        variable address : std_logic_vector(ADDR_WIDTH-1 downto 0);
        variable data : std_logic_vector(DATA_WIDTH-1 downto 0);
          variable RV : RandomPType;

        variable AddressCov : CoverageIDType;

    begin
        AddressCov:= NewID("AddressCov");

        AddBins(AddressCov,1024, GenBin(0, 1023, 16));

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

            address :=  std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            data :=  std_logic_vector(to_unsigned(i * 16#1111#, DATA_WIDTH));

            -- Write DUT

            RamWrite(               --usando las transacciones desde ram.bfm
               tr_rec   => tr_rec,
                clk     => clk,
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
               tr_rec  => tr_rec,
                clk     => clk,
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
                tr_rec  => tr_rec,
                clk     => clk,
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

            -- Read DUT

            RamRead(
               tr_rec  => tr_rec,
                clk     => clk,
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


        for i in 0 to 9999 loop

      -- Generate random address and data

        address := RV.RandSlv(ADDR_WIDTH);
        data    := RV.RandSlv(DATA_WIDTH);
            ICover(AddressCov, to_integer(unsigned(address)));
            -- Deterministic pseudo-random data
           -- data := std_logic_vector(to_unsigned(i * 12345, DATA_WIDTH));

            if (i mod 2) = 0 then

                ------------------------------------------------
                -- WRITE
                ------------------------------------------------

                RamWrite(
                   tr_rec  => tr_rec,
                   clk     => clk,
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
                 tr_rec  => tr_rec,
                   clk     => clk,
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

        Report("Address coverage = " &
        real'image(GetCov(AddressCov)));
        Writebin(AddressCov);
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
