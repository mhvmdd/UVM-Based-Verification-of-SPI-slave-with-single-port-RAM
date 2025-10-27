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
            
        endgroup
        function new (string name = "WRAPPER_coverage", uvm_component parent = null);
            super.new(name, parent);
            //Create Covergroup 
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
                //Sample
            end
        endtask


    endclass
endpackage