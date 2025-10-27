package SPI_slave_scoreboard_pkg;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_scoreboard extends  uvm_scoreboard;
    `uvm_component_utils(SPI_slave_scoreboard)

    uvm_analysis_export #(SPI_slave_seq_item) sb_export;
    uvm_tlm_analysis_fifo #(SPI_slave_seq_item) sb_fifo;
    SPI_slave_seq_item seq_item_sb;

    int rx_valid_error_count = 0;
    int rx_data_error_count = 0;
    int MISO_error_count = 0;
    int rx_valid_correct_count = 0;
    int rx_data_correct_count = 0;
    int MISO_correct_count = 0;

    function new(string name = "SPI_slave_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(seq_item_sb);
            if (seq_item_sb.rx_data != seq_item_sb.rx_data_ref) begin
                `uvm_error("run_phase", $sformatf("Comparsion of rx_data failed, DUT:%s While rx_data_ref = %h", seq_item_sb.convert2string(), seq_item_sb.rx_data_ref));
                rx_data_error_count++;
            end 
            else rx_data_correct_count++;

            if (seq_item_sb.rx_valid != seq_item_sb.rx_valid_ref) begin
                `uvm_error("run_phase", $sformatf("comparsion of rx_valid failed, DUT:%s While rx_valid_ref = %b", seq_item_sb.convert2string(), seq_item_sb.rx_valid_ref));
                rx_valid_error_count++;
            end 
            else rx_valid_correct_count++;

            if (seq_item_sb.MISO != seq_item_sb.MISO_ref) begin
                `uvm_error("run_phase", $sformatf("comparsion of MISO failed, DUT:%s While MISO_ref = %b", seq_item_sb.convert2string(), seq_item_sb.MISO_ref));
                MISO_error_count++;
            end 
            else MISO_correct_count++;
        end
    endtask

    function void report_phase (uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", "SPI SLAVE SCOREBOARD", UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total successful rx_data: %d", rx_data_correct_count), UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total failed rx_data: %d", rx_data_error_count), UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total successful rx_valid: %d", rx_valid_correct_count), UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total failed rx_valid: %d", rx_valid_error_count), UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total successful MISO: %d", MISO_correct_count), UVM_LOW);
        `uvm_info("report_phase", $sformatf("Total failed MISO: %d", MISO_error_count), UVM_LOW);
    endfunction
endclass
endpackage