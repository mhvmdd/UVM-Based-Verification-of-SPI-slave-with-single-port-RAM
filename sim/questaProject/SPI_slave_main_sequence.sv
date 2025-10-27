package SPI_slave_main_sequence_pkg;
import uvm_pkg::*;
import SPI_slave_seq_item_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_main_sequence extends uvm_sequence #(SPI_slave_seq_item);
    `uvm_object_utils(SPI_slave_main_sequence);

    SPI_slave_seq_item seq_item;

    function new(string name = "SPI_slave_main_sequence");
        super.new(name);
    endfunction

    task body;
        seq_item = SPI_slave_seq_item::type_id::create("seq_item");
        repeat(20000) begin
            start_item(seq_item);
            assert(seq_item.randomize());        
            finish_item(seq_item);
        end
    endtask
endclass
endpackage