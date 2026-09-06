# --------------------------------------------------
# Start simulation
# --------------------------------------------------

vsim -voptargs=+acc work.ram_tb


# --------------------------------------------------
# Waveforms
# --------------------------------------------------

add wave -divider "CLOCK"

add wave sim:/ram_tb/clk
add wave sim:/ram_tb/reset


add wave -divider "RAM"

add wave sim:/ram_tb/wr_en
add wave sim:/ram_tb/rd_en
add wave sim:/ram_tb/addr
add wave sim:/ram_tb/wr_data
add wave sim:/ram_tb/rd_data


# --------------------------------------------------
# Run
# --------------------------------------------------

run -all
