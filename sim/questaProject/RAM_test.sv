package RAM_test_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    import RAM_config_pkg::*;
    import RAM_sequence_pkg::*;
    import RAM_seq_item_pkg::*;
    import RAM_env_pkg::*;
    class RAM_test extends uvm_test;
        `uvm_component_utils(RAM_test)

        RAM_env ram_env;

        RAM_config ram_cfg;

        RAM_reset_seq ram_reset;
        RAM_write_only_seq ram_write_only;
        RAM_read_only_seq ram_read_only;
        RAM_write_read_seq ram_write_read;

        function new (string name = "RAM_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ram_cfg = RAM_config::type_id::create("ram_cfg", this);
            ram_env = RAM_env::type_id::create("ram_env",this);

            ram_reset = RAM_reset_seq::type_id::create("ram_reset");
            ram_write_only = RAM_write_only_seq::type_id::create("ram_write_only");
            ram_read_only = RAM_read_only_seq::type_id::create("ram_read_only");
            ram_write_read = RAM_write_read_seq::type_id::create("ram_write_read");

            ram_cfg.is_active = UVM_ACTIVE;
            if (!uvm_config_db #(virtual RAM_IF)::get(this,"","RAM_IF",ram_cfg.ram_if))
                `uvm_fatal("build_phase", "Error - Test cannot retrieve the RAM interface");
            uvm_config_db #(RAM_config)::set(this, "*", "CFG_RAM", ram_cfg);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            //RAM_1
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            ram_reset.start(ram_env.ram_agt.ram_sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);
            // RAM_2, RAM_3
            `uvm_info("run_phase", "Write Only Seq Started", UVM_LOW);
            ram_write_only.start(ram_env.ram_agt.ram_sqr);
            `uvm_info("run_phase", "Write Only Seq Ended", UVM_LOW);
            //RAM_4, RAM_5
            `uvm_info("run_phase", "Read Only Seq Started", UVM_LOW);
            is_readOnly = 1;
            ram_read_only.start(ram_env.ram_agt.ram_sqr);
            is_readOnly = 0;
            `uvm_info("run_phase", "Read Only Seq Ended", UVM_LOW);
            //RAM_6, RAM_7, RAM_8, RAM_9
            `uvm_info("run_phase", "Write Read Seq Started", UVM_LOW);
            ram_write_read.start(ram_env.ram_agt.ram_sqr);
            `uvm_info("run_phase", "Write Read Seq Ended", UVM_LOW);

            phase.drop_objection(this);
        endtask
    endclass
endpackage