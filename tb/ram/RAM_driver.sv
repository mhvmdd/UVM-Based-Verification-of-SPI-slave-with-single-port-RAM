package RAM_driver_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import RAM_seq_item_pkg::*;
    class RAM_driver extends uvm_driver #(RAM_seq_item);
        `uvm_component_utils(RAM_driver)

        RAM_seq_item dvr_seq_item;
        virtual RAM_IF ram_dvr_if;
    
        function new (string name = "RAM_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                dvr_seq_item = RAM_seq_item::type_id::create("dvr_seq_item");
                seq_item_port.get_next_item(dvr_seq_item);
                ram_dvr_if.rst_n = dvr_seq_item.rst_n;
                ram_dvr_if.rx_valid = dvr_seq_item.rx_valid;
                ram_dvr_if.din = dvr_seq_item.din;
                repeat(1)@(negedge ram_dvr_if.clk);
                seq_item_port.item_done();
                `uvm_info("run_phase", dvr_seq_item.convert2string_stimulus, UVM_HIGH);
            end
        endtask
    endclass
endpackage