vlib work
vlog +define+SIM  -f src_files.list +cover -covercells
vsim -voptargs=+acc work.WRAPPER_top -classdebug -uvmcontrol=all -cover
add wave -position insertpoint sim:/WRAPPER_top/DUT_WRAPPER/SLAVE_instance/*
add wave -position insertpoint  \
sim:/WRAPPER_top/DUT_WRAPPER/RAM_instance/din \
sim:/WRAPPER_top/DUT_WRAPPER/RAM_instance/dout \
sim:/WRAPPER_top/DUT_WRAPPER/RAM_instance/MEM  \
sim:/WRAPPER_top/DUT_WRAPPER/RAM_instance/Rd_Addr \
sim:/WRAPPER_top/DUT_WRAPPER/RAM_instance/Wr_Addr 
coverage save wrapper.ucdb -onexit
run -all