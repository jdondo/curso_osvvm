# --------------------------------------------------
# Start simulation
# --------------------------------------------------

vsim -coverage -voptargs=+acc work.ram_tb


# --------------------------------------------------
# Waveforms
# --------------------------------------------------

add wave -divider "CLOCK"

add wave sim:/ram_tb/clk
add wave sim:/ram_tb/reset


add wave -divider "RAM"

add wave sim:/ram_tb/tr_rec




# --------------------------------------------------
# Run
# --------------------------------------------------

run -all
