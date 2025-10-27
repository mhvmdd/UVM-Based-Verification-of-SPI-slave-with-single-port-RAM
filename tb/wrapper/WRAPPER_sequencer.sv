package WRAPPER_sequencer_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_seq_item_pkg::*;
    class WRAPPER_sequencer extends uvm_sequencer #(WRAPPER_seq_item);
        `uvm_component_utils(WRAPPER_sequencer)

        function new (string name = "WRAPPER_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction
    endclass
endpackage