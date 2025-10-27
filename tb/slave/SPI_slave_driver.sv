package SPI_slave_driver_pkg;
import uvm_pkg::*;
import SPI_slave_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_driver extends uvm_driver #(SPI_slave_seq_item);
    `uvm_component_utils(SPI_slave_driver);

    virtual SPI_slave_if slave_if;
    SPI_slave_seq_item stim_seq_item;

    function new(string name = "SPI_slave_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stim_seq_item = SPI_slave_seq_item::type_id::create("stim_seq_item");
            seq_item_port.get_next_item(stim_seq_item);
            slave_if.rst_n = stim_seq_item.rst_n;
            slave_if.SS_n = stim_seq_item.SS_n;
            slave_if.tx_valid = stim_seq_item.tx_valid;
            slave_if.tx_data = stim_seq_item.tx_data;
            slave_if.MOSI = stim_seq_item.MOSI;
            @(negedge slave_if.clk);
            seq_item_port.item_done();
            `uvm_info("run_phase", stim_seq_item.convert2string_stimulus(), UVM_HIGH);
        end
    endtask
endclass

endpackage