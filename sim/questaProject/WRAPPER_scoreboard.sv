package WRAPPER_scoreboard_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_seq_item_pkg::*;
    class WRAPPER_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(WRAPPER_scoreboard)


        uvm_analysis_export #(WRAPPER_seq_item) sb_axp;
        uvm_tlm_analysis_fifo #(WRAPPER_seq_item) sb_fifo;

        WRAPPER_seq_item sb_seq_item;

        int error_cnt = 0, correct_cnt = 0;

        function new (string name = "WRAPPER_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_axp = new("sb_axp", this);
            sb_fifo = new("sb_fifo", this);
        
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_axp.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_seq_item);
                if (
                    sb_seq_item.MISO != sb_seq_item.MISO_ref
                ) begin
                    error_cnt++;
                    `uvm_error("run_phase", $sformatf("Comparison Failed - Transaction Received DUT : %s, Ref Model : MISO = %b", sb_seq_item.convert2string, sb_seq_item.MISO_ref));
                end
                else begin
                    correct_cnt++;
                    `uvm_info("run_phase", $sformatf("Correct RAM Comparison: %s", sb_seq_item.convert2string),UVM_HIGH);
                end
            end
        endtask

        function void report_phase (uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Correct Tests = %d, Error Tests = %d", correct_cnt, error_cnt),UVM_MEDIUM)
        endfunction  
    endclass
endpackage