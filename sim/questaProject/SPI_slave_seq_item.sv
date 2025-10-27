package SPI_slave_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_seq_item extends uvm_sequence_item;
    `uvm_object_utils(SPI_slave_seq_item);
    rand logic rst_n, MOSI, SS_n, tx_valid;
    rand logic [7:0] tx_data;
    logic [9:0] rx_data, rx_data_ref;
    logic rx_valid, rx_valid_ref, MISO, MISO_ref; 

    rand bit [10:0] MOSI_array;
    static bit [1:0] state = 2'b00;
    int count;

    function new(string name = "SPI_slave_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , MISO = 0b%0b , tx_data = 0x%02h , rx_valid = 0b%0b , rx_data = 0x%03h",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data, MISO, rx_valid, rx_data);
    endfunction

    function string convert2string_stimulus();
        return $sformatf("%s rst_n = 0b%0b , MOSI = 0b%0b , SS_n = 0b%0b , tx_valid = 0b%0b , tx_data = 0x%02h",
            super.convert2string(), rst_n, MOSI, SS_n, tx_valid, tx_data);
    endfunction

    // SLAVE_1
    constraint rst_n_const{
        rst_n dist {0:/1, 1:/99};
    }

    // SLAVE_2
    constraint SS_n_const{
        if(MOSI_array[10:8] == 3'b111){
            if(count == 23) SS_n == 1;
            else SS_n == 0;
        }
        else{
            if(count == 13) SS_n == 1;
            else SS_n == 0;
        }
    }

    // SLAVE_3
    constraint MOSI_array_const{
        MOSI_array[10] == state[1];
        MOSI_array[9:8] == state;
    }

    // SLAVE_4
    constraint MOSI_const{
       if (count > 0 && count < 12) MOSI == MOSI_array[11 - count];
    }

    // SLAVE_5
    constraint tx_valid_const{
        if(MOSI_array[10:8] == 3'b111 && count > 13 && count < 24) tx_valid == 1;
        else tx_valid == 0;
    }


    function void pre_randomize();
        if(count==0) MOSI_array.rand_mode(1);
		else MOSI_array.rand_mode(0);     

        if(MOSI_array[10:8] == 3'b111 && count == 12) tx_data.rand_mode(1);
        else tx_data.rand_mode(0);

    endfunction

    function void post_randomize();
        if(SS_n || !rst_n) count = 0;
        else count++;
        if(!rst_n) state = 0;
        else if(count == 0) state++;
    endfunction

endclass

endpackage