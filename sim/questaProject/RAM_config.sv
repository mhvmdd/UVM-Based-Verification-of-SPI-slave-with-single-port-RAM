package RAM_config_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    class RAM_config extends uvm_object;
        `uvm_object_utils(RAM_config) 

        virtual RAM_IF ram_if;
        uvm_active_passive_enum is_active;

        function new(string name = "RAM_config");
            super.new(name);
        endfunction //new()
    endclass //RAM_config extends uvm_object
endpackage