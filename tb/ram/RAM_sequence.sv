package RAM_sequence_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    import RAM_seq_item_pkg::*;
    class RAM_reset_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_reset_seq)

        RAM_seq_item ram_seq;

        function new(string name = "RAM_reset_seq");
            super.new(name);    
        endfunction
    // RAM_1
        virtual task body();
            ram_seq = RAM_seq_item::type_id::create("ram_seq");
            start_item(ram_seq);
            ram_seq.rst_n = 0;
            ram_seq.rx_valid = 0;
            ram_seq.din = 0;
            finish_item(ram_seq);
        endtask
    endclass
    class RAM_write_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_write_only_seq)

        RAM_seq_item ram_seq;

        function new(string name = "RAM_write_only_seq");
            super.new(name);    
        endfunction
// RAM_2, RAM_3
        virtual task body();
            repeat(10000)begin
                ram_seq = RAM_seq_item::type_id::create("ram_seq");
                start_item(ram_seq);
                ram_seq.read_only_const.constraint_mode(0);
                ram_seq.write_read_const.constraint_mode(0);
                assert(ram_seq.randomize);
                finish_item(ram_seq);
            end
        endtask
    endclass
    class RAM_read_only_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_read_only_seq)

        RAM_seq_item ram_seq;

        function new(string name = "RAM_read_only_seq");
            super.new(name);    
        endfunction
//RAM_4, RAM_5
        virtual task body();
            repeat(10000)begin
                ram_seq = RAM_seq_item::type_id::create("ram_seq");
                start_item(ram_seq);
                ram_seq.write_only_const.constraint_mode(0);
                ram_seq.write_read_const.constraint_mode(0);
                assert(ram_seq.randomize);
                finish_item(ram_seq);
            end
        endtask
    endclass
    class RAM_write_read_seq extends uvm_sequence #(RAM_seq_item);
        `uvm_object_utils(RAM_write_read_seq)

        RAM_seq_item ram_seq;

        function new(string name = "RAM_write_read_seq");
            super.new(name);    
        endfunction
//RAM_6, RAM_7, RAM_8, RAM_9
        virtual task body();
            repeat(10000)begin
                ram_seq = RAM_seq_item::type_id::create("ram_seq");
                start_item(ram_seq);
                ram_seq.write_only_const.constraint_mode(0);
                ram_seq.read_only_const.constraint_mode(0);
                assert(ram_seq.randomize);
                finish_item(ram_seq);
            end
        endtask
    endclass
endpackage