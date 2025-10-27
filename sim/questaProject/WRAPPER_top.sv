import uvm_pkg::*;
`include"uvm_macros.svh"
import WRAPPER_test_pkg::*;
module WRAPPER_top;
    logic clk = 0;
    initial begin
        $readmemb("mem.dat", DUT_WRAPPER.RAM_instance.MEM);
        $readmemb("mem.dat", GM_WRAPPER.RAM_instance.mem);
        
        forever #1 clk = ~clk;
    end

    WRAPPER_IF wrapper_if(clk);
    RAM_IF ram_if(clk);
    SPI_slave_if slave_if(clk);

    WRAPPER DUT_WRAPPER (
        .clk(wrapper_if.clk),
        .rst_n(wrapper_if.rst_n),
        .MOSI(wrapper_if.MOSI),
        .SS_n(wrapper_if.SS_n),
        .MISO(wrapper_if.MISO)
    );

    WRAPPER_ref GM_WRAPPER(
        .clk(wrapper_if.clk),
        .rst_n(wrapper_if.rst_n),
        .MOSI(wrapper_if.MOSI),
        .SS_n(wrapper_if.SS_n),
        .MISO(wrapper_if.MISO_ref)
    );

//RAM Inputs
    assign ram_if.rst_n = DUT_WRAPPER.rst_n;
    assign ram_if.rx_valid = DUT_WRAPPER.rx_valid;
    assign ram_if.din = DUT_WRAPPER.rx_data_din;
    assign ram_if.dout = DUT_WRAPPER.tx_data_dout;
    assign ram_if.tx_valid = DUT_WRAPPER.tx_valid;
    assign ram_if.dout_ref = GM_WRAPPER.tx_data_dout;
    assign ram_if.tx_valid_ref = GM_WRAPPER.tx_valid;


//Slave Inputs
    assign slave_if.rst_n = DUT_WRAPPER.rst_n;
    assign slave_if.SS_n = DUT_WRAPPER.SS_n;
    assign slave_if.tx_valid = DUT_WRAPPER.tx_valid;
    assign slave_if.tx_data = DUT_WRAPPER.tx_data_dout;
    assign slave_if.MOSI = DUT_WRAPPER.MOSI;
    assign slave_if.rx_data = DUT_WRAPPER.rx_data_din;
    assign slave_if.rx_data_ref = GM_WRAPPER.rx_data_din;
    assign slave_if.MISO = DUT_WRAPPER.MISO;
    assign slave_if.MISO_ref = GM_WRAPPER.MISO;
    assign slave_if.rx_valid = DUT_WRAPPER.rx_valid;
    assign slave_if.rx_valid_ref = GM_WRAPPER.rx_valid;


    bind RAM RAM_sva RAM_sva_inst(
        .clk(ram_if.clk),
        .rst_n(ram_if.rst_n),
        .rx_valid(ram_if.rx_valid),
        .din(ram_if.din),
        .tx_valid(ram_if.tx_valid),
        .dout(ram_if.dout)
    );

    bind WRAPPER WRAPPER_sva WRAPPER_sva_inst(
        .clk(wrapper_if.clk),
        .rst_n(wrapper_if.rst_n),
        .MOSI(wrapper_if.MOSI),
        .SS_n(wrapper_if.SS_n),
        .MISO(wrapper_if.MISO),
        .rx_data_din(WRAPPER.rx_data_din),
        .rx_valid(WRAPPER.rx_valid),
        .tx_valid(WRAPPER.tx_valid),
        .operation(WRAPPER.SLAVE_instance.cs)
    );

    initial begin
        uvm_config_db #(virtual WRAPPER_IF)::set(null,"uvm_test_top","WRAPPER_IF", wrapper_if);
        uvm_config_db #(virtual SPI_slave_if)::set(null,"uvm_test_top","SLAVE_IF", slave_if);
        uvm_config_db #(virtual RAM_IF)::set(null,"uvm_test_top","RAM_IF", ram_if);
        run_test("WRAPPER_test");
    end

endmodule