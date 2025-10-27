package WRAPPER_seq_item_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    class WRAPPER_seq_item extends uvm_sequence_item;
        `uvm_object_utils(WRAPPER_seq_item)
    // Signals Delarations
        rand logic   MOSI, SS_n, rst_n;
        logic   MISO;
        logic   MISO_ref;


        static logic [2:0] state;
        static int count = 0;
        rand bit [10:0] MOSI_array;
        static bit rand_ok;

    // Functions 
        function new(string name = "WRAPPER_seq_item");
            super.new(name);
            state = 2'b00;
            MOSI_array = 2'b00;
        endfunction

        function string convert2string();
            return $sformatf("%s ", super.convert2string);
        endfunction
        function string convert2string_stimulus();
            return $sformatf("%s ", super.convert2string);
        endfunction
        function void pre_randomize();
            if (count == 0) begin
                MOSI_array.rand_mode(1);
                rand_ok = 1;
            end
            else begin
                MOSI_array.rand_mode(0);
                rand_ok = 0;
            end
        endfunction
        function void post_randomize();
            if(SS_n || !rst_n) count = 0;
            else count++;
            state = MOSI_array[10:8];
            $display("time = %t, count = %d, state = %b", $time, count, state);
        endfunction


    //Constraints
    constraint reset_const{
        rst_n dist {1:/99 , 0:/1};
    };

    // constraint MOSI_array_const{
    //     MOSI_array[10] == state[1];
    //     MOSI_array[9:8] == state;
    // };

    constraint MOSI_const{
        if (count > 0 && count < 12) MOSI == MOSI_array [11 - (count)]; // 10 
    };
    constraint SS_n_const{
            if(MOSI_array[10:8] == 3'b111){
                if(count == 23) SS_n == 1;
                else SS_n == 0;
            }
            else{
                if(count == 13) SS_n == 1;
                else SS_n == 0;
            }
    };
    constraint write_only_const{
        MOSI_array[10:8] inside {3'b000, 3'b001};
    };
    constraint read_only_const{
        if (state == 3'b110) MOSI_array[10:8] == 3'b111;
        else if (state == 3'b111) MOSI_array[10:8] == 3'b110;
    };
    constraint write_read_const{
        if (state == 3'b000) {
            MOSI_array[10:8] inside {3'b000, 3'b001};
        }
        else if (state == 3'b001) {
            MOSI_array[10:8] dist {3'b110:/60, 3'b000:/40};
        }
        else if (state == 3'b110) {
            MOSI_array[10:8] == 3'b111;
        }
        else if (state == 3'b111) {
            MOSI_array[10:8] dist {3'b000:/60, 3'b110:/40};
        }
    };
    endclass
endpackage