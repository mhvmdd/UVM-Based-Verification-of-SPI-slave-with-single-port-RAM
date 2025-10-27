package RAM_monitor_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import RAM_seq_item_pkg::*;
    class RAM_monitor extends uvm_monitor;
        `uvm_component_utils(RAM_monitor)

        virtual RAM_IF ram_mon_if;
        RAM_seq_item mon_seq_item;

        uvm_analysis_port #(RAM_seq_item) mon_ap;

        function new (string name = "RAM_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap", this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                mon_seq_item = RAM_seq_item::type_id::create("mon_seq_item");
                repeat(1)@(negedge ram_mon_if.clk);
                mon_seq_item.rst_n = ram_mon_if.rst_n;
                mon_seq_item.rx_valid = ram_mon_if.rx_valid;
                mon_seq_item.din = ram_mon_if.din;
                mon_seq_item.dout = ram_mon_if.dout;
                mon_seq_item.tx_valid = ram_mon_if.tx_valid;
                mon_seq_item.dout_ref = ram_mon_if.dout_ref;
                mon_seq_item.tx_valid_ref = ram_mon_if.tx_valid_ref;
                mon_ap.write(mon_seq_item);
                `uvm_info("run_phase", mon_seq_item.convert2string, UVM_HIGH);
            end
        endtask


    endclass
endpackage