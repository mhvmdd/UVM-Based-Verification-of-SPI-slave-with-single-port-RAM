package SPI_slave_monitor_pkg;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_monitor extends uvm_monitor;
    `uvm_component_utils(SPI_slave_monitor);

    SPI_slave_seq_item rsp_seq_item;
    virtual SPI_slave_if slave_if;
    uvm_analysis_port #(SPI_slave_seq_item) mon_ap;

    function new(string name = "SPI_slave_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_ap = new("mon_ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            rsp_seq_item = SPI_slave_seq_item::type_id::create("rsp_seq_item");
            @(negedge slave_if.clk);
            rsp_seq_item.rst_n = slave_if.rst_n;
            rsp_seq_item.SS_n = slave_if.SS_n;
            rsp_seq_item.MOSI  = slave_if.MOSI;
            rsp_seq_item.tx_valid = slave_if.tx_valid;
            rsp_seq_item.tx_data = slave_if.tx_data;
            rsp_seq_item.rx_valid = slave_if.rx_valid;
            rsp_seq_item.rx_data = slave_if.rx_data;
            rsp_seq_item.MISO = slave_if.MISO;
            rsp_seq_item.rx_valid_ref = slave_if.rx_valid_ref;
            rsp_seq_item.rx_data_ref = slave_if.rx_data_ref;
            rsp_seq_item.MISO_ref = slave_if.MISO_ref;
            mon_ap.write(rsp_seq_item);
            `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
        end
    endtask
endclass
endpackage