package WRAPPER_coverage_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"

    import WRAPPER_seq_item_pkg::*;
    import shared_pkg::*;
    class WRAPPER_coverage extends uvm_component;
        `uvm_component_utils(WRAPPER_coverage)
        
        uvm_analysis_export #(WRAPPER_seq_item) cvg_axp;
        uvm_tlm_analysis_fifo #(WRAPPER_seq_item) cvg_fifo;

        WRAPPER_seq_item cvg_seq_item;

        //Cover Groups
        covergroup WRAPPER_CVG;
            SS_n_cp: coverpoint cvg_seq_item.SS_n {
                bins normal_trans = (1 => 0[*13] => 1);
                bins extended_trans = (1 => 0[*23] => 1);
            }

            MOSI_cp: coverpoint cvg_seq_item.MOSI{
                bins write_address = (0 => 0 => 0);
                bins write_data    = (0 => 0 => 1);
                bins read_address  = (1 => 1 => 0);
                bins read_data     = (1 => 1 => 1);
            }

            SS_n_MOSI_cr: cross SS_n_cp, MOSI_cp{
                ignore_bins not_r_data_ext1 = binsof(MOSI_cp.write_address) && binsof(SS_n_cp.extended_trans);
                ignore_bins not_r_data_ext2 = binsof(MOSI_cp.write_data) && binsof(SS_n_cp.extended_trans);
                ignore_bins not_r_data_ext3 = binsof(MOSI_cp.read_address) && binsof(SS_n_cp.extended_trans);
                ignore_bins not_r_data_ext4 = binsof(MOSI_cp.read_data) && binsof(SS_n_cp.normal_trans);
            }
        endgroup
        function new (string name = "WRAPPER_coverage", uvm_component parent = null);
            super.new(name, parent);
            WRAPPER_CVG = new;
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            cvg_axp = new ("cvg_axp", this);
            cvg_fifo = new ("cvg_fifo", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cvg_axp.connect(cvg_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cvg_fifo.get(cvg_seq_item);
                WRAPPER_CVG.sample();
            end
        endtask


    endclass
endpackage