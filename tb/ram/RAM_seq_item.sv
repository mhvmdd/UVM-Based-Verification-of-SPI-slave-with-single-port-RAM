package RAM_seq_item_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    class RAM_seq_item extends uvm_sequence_item;
        `uvm_object_utils(RAM_seq_item)
    // Signals Delarations
        rand logic      [9:0] din;
        rand logic rst_n, rx_valid;

        logic [7:0] dout;
        logic       tx_valid;
        logic [7:0] dout_ref;
        logic       tx_valid_ref;
        
        op_e wr_op[] = '{WRITE_ADDR, WRITE_DATA};
        op_e rd_op[] = '{READ_ADDR, READ_DATA};

        bit wr_addr, wr_data, rd_addr, rd_data;

        rand op_e op_rd_data, op_wr_data;

        static op_e last_op;
    // Functions 
        function new(string name = "RAM_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s - reset = %b, rx_valid = %b, din = %h ---- tx_valid = %b, dout = %h", super.convert2string, rst_n, rx_valid, din, tx_valid, dout);
        endfunction
        function string convert2string_stimulus();
            return $sformatf("%s - reset = %b, rx_valid = %b, din = %h", super.convert2string, rst_n, rx_valid, din);
        endfunction
        function void post_randomize();
            last_op = op_e'{din[9:8]};
        endfunction
    //Constraints
    //RAM_1
    constraint reset_const{
        rst_n dist {1:/90 , 0:/10};
    };
    // RAM_2, RAM_3    
    constraint rx_valid_const{
        rx_valid dist {1:/90 , 0:/10};
    };
    // RAM_2, RAM_3 //
    constraint write_only_const{
        din[9:8] inside {wr_op};
    };
    //RAM_4, RAM_5
    constraint read_only_const{
        din[9:8] inside {rd_op};
    };
    //RAM_6, RAM_7, RAM_8, RAM_9
    constraint write_read_const{
        op_rd_data dist {WRITE_ADDR:=60 , READ_ADDR:=40};
        op_wr_data dist {READ_ADDR:=60 , WRITE_ADDR:=40};

        (last_op == READ_ADDR) -> din[9:8] inside {rd_op};
        (last_op == READ_DATA) -> din[9:8] == op_rd_data;
        (last_op == WRITE_ADDR) -> din[9:8] inside {wr_op};
        (last_op == WRITE_DATA) -> din[9:8] == op_wr_data;
    };
    endclass
endpackage