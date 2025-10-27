package WRAPPER_monitor_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_seq_item_pkg::*;
    class WRAPPER_monitor extends uvm_monitor;
        `uvm_component_utils(WRAPPER_monitor)

        virtual WRAPPER_IF wrapper_mon_if;
        WRAPPER_seq_item mon_seq_item;

        uvm_analysis_port #(WRAPPER_seq_item) mon_ap;

        function new (string name = "WRAPPER_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                mon_seq_item = WRAPPER_seq_item::type_id::create("mon_seq_item");
                //Monitor the signals
                repeat(1)@(negedge wrapper_mon_if.clk);
                mon_seq_item.rst_n = wrapper_mon_if.rst_n;
                mon_seq_item.MOSI = wrapper_mon_if.MOSI;
                mon_seq_item.SS_n = wrapper_mon_if.SS_n;
                mon_seq_item.MISO = wrapper_mon_if.MISO;
                mon_seq_item.MISO_ref = wrapper_mon_if.MISO_ref;
                mon_ap.write(mon_seq_item);
                `uvm_info("run_phase", mon_seq_item.convert2string, UVM_HIGH);
            end
        endtask


    endclass
endpackage