package RAM_scoreboard_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import RAM_seq_item_pkg::*;
    class RAM_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(RAM_scoreboard)

        logic [7:0] dout_ref;
        logic       tx_valid_ref;   

        logic [7:0] Rd_Addr, Wr_Addr;

        logic [7:0] MEM_ref [logic[7:0]];

        uvm_analysis_export #(RAM_seq_item) sb_axp;
        uvm_tlm_analysis_fifo #(RAM_seq_item) sb_fifo;

        RAM_seq_item sb_seq_item;

        int error_cnt = 0, correct_cnt = 0;

        function new (string name = "RAM_scoreboard", uvm_component parent = null);
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
                // ref_model(sb_seq_item);
                if (
                    sb_seq_item.tx_valid_ref != sb_seq_item.tx_valid ||
                    sb_seq_item.dout_ref != sb_seq_item.dout
                ) begin
                    error_cnt++;
                    `uvm_error("run_phase", $sformatf("Comparison Failed - Transaction Received DUT : %s, Ref Model : tx_valid = %b, dout = %h", sb_seq_item.convert2string, 
                                                                        sb_seq_item.tx_valid_ref, sb_seq_item.dout_ref));
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