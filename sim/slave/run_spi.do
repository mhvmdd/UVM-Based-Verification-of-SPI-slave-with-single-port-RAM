vlib work
vlog +define+SIM -f src_list.list +cover -covercells
vsim -voptargs=+acc work.SPI_slave_top -classdebug -uvmcontrol=all -cover

add wave /SPI_slave_top/slave_if/*

add wave -position insertpoint  \
sim:/SPI_slave_top/DUT/cs  \
sim:/SPI_slave_top/DUT/ns  \
sim:/SPI_slave_top/DUT/counter  \
sim:/SPI_slave_top/GOLDEN/cnt  \
sim:/SPI_slave_top/DUT/received_address  \
sim:/SPI_slave_top/GOLDEN/rx_type 

coverage exclude -src SPI_slave.sv -line 38 -code s
coverage exclude -src SPI_slave.sv -line 37 -code b
coverage exclude -src SPI_slave.sv -line 128 -code b


run -all

coverage exclude -cvgpath {/SPI_slave_coverage_pkg/SPI_slave_coverage/covgrp/\/SPI_slave_coverage_pkg::SPI_slave_coverage::covgrp /rx_data_cp/rx_data_trans[0=>2]}


coverage save SLAVE.ucdb -onexit