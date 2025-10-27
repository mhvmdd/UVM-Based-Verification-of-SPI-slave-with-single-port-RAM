package WRAPPER_seq_item_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    class WRAPPER_seq_item extends uvm_sequence_item;
        `uvm_object_utils(WRAPPER_seq_item)
    // Signals Delarations
        rand bit   MOSI, SS_n,rst_n;;
        bit   MISO;
        bit   MISO_ref;

        rand bit [1:0] state = 2'b00;
        static bit [1:0] state_old = 2'b00;
        int count = 0;
        bit SS_n_HIGH = 1;
        rand bit [10:0] MOSI_array;

        static bit rand_ok, read_add_ok, read_type;

    // Functions 
        function new(string name = "WRAPPER_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s - rst_n = %b , SS_n = %b, MOSI = %b, DUT: MISO = %b", super.convert2string, rst_n, SS_n, MOSI, MISO);
        endfunction
        function string convert2string_stimulus();
            return $sformatf("%s - rst_n = %b , SS_n = %b, MOSI = %b", super.convert2string, rst_n, SS_n, MOSI);
        endfunction
        function void pre_randomize();
            if (count == 0 || !rst_n) begin
                MOSI_array.rand_mode(1);
                state.rand_mode(1);
                rand_ok = 1;
            end
            else begin
                MOSI_array.rand_mode(0);
                state.rand_mode(0);
                rand_ok = 0;
            end
        endfunction
        function void post_randomize();
            begin
                if (!rst_n || SS_n) begin 
                    count = 0;
                    SS_n_HIGH = 0;
                end
                else count ++;

                if (count > 12 && count < 23) begin
                    if (state != 2'b11) begin
                        SS_n_HIGH = 1;
                    end
                    else SS_n_HIGH = 0;
                end else if (count == 23) begin
                    if (state == 2'b11) begin
                        SS_n_HIGH = 1;
                    end
                    else SS_n_HIGH = 0;
                end
                else SS_n_HIGH = 0;

                
                state_old = state;

                if(state_old == 2'b01) read_type = 0;
                else if(state_old == 2'b11) read_type = 1;
                if(!rst_n && (state_old[1] == 1)) read_add_ok = 1;
                else read_add_ok = 0;
            end
        endfunction

    constraint reset_const{
        rst_n dist {1:=99, 0:=1};
    };

    constraint MOSI_array_const{
        MOSI_array[10] == state[1];
        MOSI_array[9:8] == state;
    };

    constraint MOSI_const{
        if (count > 0 && count < 12) MOSI == MOSI_array [11 - (count)]; // 10 
    };
    constraint SS_n_const{
        SS_n == SS_n_HIGH;
    };
    constraint write_only_const{
        state inside {2'b00, 2'b01};
    };
    constraint read_only_const{
        if (start_read || read_add_ok ||  (state_old == 2'b11 && rand_ok)) { // Read data
            state == 2'b10;
        }
        else if (state_old == 2'b10 && rand_ok) { //read Addr
            state == 2'b11;
        }
    };
    constraint write_read_const{
        if (start_read || read_add_ok || (state_old == 2'b00 && rand_ok)) {
            state inside {2'b00, 2'b01};
        }
        else if (state_old == 2'b01 && rand_ok) {
            state dist {2'b10:/60, 2'b00:/40};
        }
        else if (state_old == 2'b11 && rand_ok) {
            state dist {2'b00:/60, 2'b10:/40};
        }
        else if (state_old == 2'b10 && rand_ok) {
            state inside {2'b11};
        } 
    };
    endclass
endpackage