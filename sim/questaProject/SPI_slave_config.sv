package SPI_slave_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_config extends uvm_object;
    `uvm_object_utils(SPI_slave_config);

    virtual SPI_slave_if slave_if;
    uvm_active_passive_enum is_active;

    function new(string name = "SPI_slave_config");
        super.new(name);
    endfunction
endclass 
    
endpackage