package WRAPPER_config_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    class WRAPPER_config extends uvm_object;
        `uvm_object_utils(WRAPPER_config) 

        virtual WRAPPER_IF wrapper_if;
        uvm_active_passive_enum is_active;

        function new(string name = "WRAPPER_config");
            super.new(name);
        endfunction //new()
    endclass //WRAPPER_config extends uvm_object
endpackage