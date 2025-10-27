package SPI_slave_coverage_pkg;
import SPI_slave_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_coverage extends  uvm_scoreboard;
    `uvm_component_utils(SPI_slave_coverage);

    uvm_analysis_export #(SPI_slave_seq_item) cov_export;
    uvm_tlm_analysis_fifo #(SPI_slave_seq_item) cov_fifo;
    SPI_slave_seq_item seq_item_cov;

    covergroup covgrp;

        rx_data_cp: coverpoint seq_item_cov.rx_data[9:8] {
            bins rx_data_all_values[] = {[0:3]}; 
            bins rx_data_trans[] = (0 => 1), (1 => 3), (1 => 0), (0 => 2),
                                   (2 => 3), (2 => 0), (3 => 1), (3 => 2);
        }

        SS_n_cp: coverpoint seq_item_cov.SS_n {
            bins normal_trans = (1 => 0[*13] => 1);
            bins extended_trans = (1 => 0[*23] => 1);
        }

        MOSI_cp: coverpoint seq_item_cov.MOSI{
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

    function new(string name = "SPI_slave_coverage", uvm_component parent = null);
        super.new(name, parent);
        covgrp = new;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(seq_item_cov);
            covgrp.sample();
        end
    endtask
endclass
endpackage