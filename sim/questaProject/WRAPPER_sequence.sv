package WRAPPER_sequence_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    class WRAPPER_reset_seq extends uvm_sequence #(WRAPPER_seq_item);
        `uvm_object_utils(WRAPPER_reset_seq)

        WRAPPER_seq_item wrapper_seq_item;

        function new (string name = "WRAPPER_reset_seq");
            super.new(name);
        endfunction

        virtual task body();
            wrapper_seq_item = WRAPPER_seq_item::type_id::create("wrapper_seq_item");
            start_item(wrapper_seq_item);
            wrapper_seq_item.rst_n = 0;
            wrapper_seq_item.MOSI = 0;
            wrapper_seq_item.SS_n = 0;
            finish_item(wrapper_seq_item);
        endtask
    endclass
    class WRAPPER_write_only_seq extends uvm_sequence #(WRAPPER_seq_item);
        `uvm_object_utils(WRAPPER_write_only_seq)

        WRAPPER_seq_item wrapper_seq_item;

        function new (string name = "WRAPPER_write_only_seq");
            super.new(name);
        endfunction

        virtual task body();
                wrapper_seq_item = WRAPPER_seq_item::type_id::create("wrapper_seq_item");
                wrapper_seq_item.read_only_const.constraint_mode(0);
                wrapper_seq_item.write_read_const.constraint_mode(0);
            repeat (1000) begin
                start_item(wrapper_seq_item);
                assert(wrapper_seq_item.randomize);
                finish_item(wrapper_seq_item);
            end
        endtask
    endclass
    class WRAPPER_read_only_seq extends uvm_sequence #(WRAPPER_seq_item);
        `uvm_object_utils(WRAPPER_read_only_seq)

        WRAPPER_seq_item wrapper_seq_item;

        function new (string name = "WRAPPER_read_only_seq");
            super.new(name);
        endfunction

        virtual task body();
                wrapper_seq_item = WRAPPER_seq_item::type_id::create("wrapper_seq_item");
                wrapper_seq_item.write_only_const.constraint_mode(0);
                wrapper_seq_item.read_only_const.constraint_mode(1);
                wrapper_seq_item.write_read_const.constraint_mode(0);
            for(int i = 0; i<1000; i++) begin
                start_item(wrapper_seq_item);
                if(i == 1) start_read = 1;
                else start_read = 0;
                assert(wrapper_seq_item.randomize);
                finish_item(wrapper_seq_item);
            end
        endtask
    endclass
    class WRAPPER_write_read_seq extends uvm_sequence #(WRAPPER_seq_item);
        `uvm_object_utils(WRAPPER_write_read_seq)

        WRAPPER_seq_item wrapper_seq_item;

        function new (string name = "WRAPPER_write_read_seq");
            super.new(name);
        endfunction

        virtual task body();
                wrapper_seq_item = WRAPPER_seq_item::type_id::create("wrapper_seq_item");
                wrapper_seq_item.write_only_const.constraint_mode(0);
                wrapper_seq_item.read_only_const.constraint_mode(0);
                wrapper_seq_item.write_read_const.constraint_mode(1);
            for(int i = 0; i<1000; i++) begin
                start_item(wrapper_seq_item);
                if(i == 1) start_read = 1;
                else start_read = 0;
                assert(wrapper_seq_item.randomize);
                finish_item(wrapper_seq_item);
            end
        endtask
    endclass
endpackage