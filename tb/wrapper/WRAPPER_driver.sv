package WRAPPER_driver_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_seq_item_pkg::*;
    class WRAPPER_driver extends uvm_driver #(WRAPPER_seq_item);
        `uvm_component_utils(WRAPPER_driver)

        WRAPPER_seq_item dvr_seq_item;
        virtual WRAPPER_IF wrapper_dvr_if;
    
        function new (string name = "WRAPPER_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                dvr_seq_item = WRAPPER_seq_item::type_id::create("dvr_seq_item");
                seq_item_port.get_next_item(dvr_seq_item);
                //Drive Signals 
                wrapper_dvr_if.rst_n = dvr_seq_item.rst_n;
                wrapper_dvr_if.MOSI = dvr_seq_item.MOSI;
                wrapper_dvr_if.SS_n = dvr_seq_item.SS_n;
                repeat(1)@(negedge wrapper_dvr_if.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", dvr_seq_item.convert2string_stimulus, UVM_HIGH);
            end
        endtask
    endclass
endpackage