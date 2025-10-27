vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.RAM_top -classdebug -uvmcontrol=all -cover
add wave /RAM_top/ram_if/*

run 0
add wave -position insertpoint  \
sim:/RAM_top/DUT/MEM \
sim:/RAM_top/DUT/Rd_Addr \
sim:/RAM_top/DUT/Wr_Addr
add wave -position insertpoint  \
sim:/shared_pkg::is_readOnly

coverage exclude -src RAM.v -line 27 -code s
coverage exclude -src RAM.v -line 27 -code b

coverage save RAM.ucdb -onexit

run -all

