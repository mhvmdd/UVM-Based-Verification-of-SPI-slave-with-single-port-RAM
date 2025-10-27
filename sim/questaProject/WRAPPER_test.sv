package WRAPPER_test_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import shared_pkg::*;
    import WRAPPER_config_pkg::*;
    import WRAPPER_sequence_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    import WRAPPER_env_pkg::*;

    import SPI_slave_env_pkg::*;
    import SPI_slave_config_pkg::*;

    import RAM_env_pkg::*;
    import RAM_config_pkg::*;

    class WRAPPER_test extends uvm_test;
        `uvm_component_utils(WRAPPER_test)

        //ENV
        WRAPPER_env wrapper_env;
        RAM_env ram_env;
        SPI_slave_env slave_env;

        //Config Obj
        WRAPPER_config wrapper_cfg;
        RAM_config ram_cfg;
        SPI_slave_config slave_cfg;

        //Sequences
        WRAPPER_reset_seq wrapper_reset;
        WRAPPER_write_only_seq wrapper_write_only;
        WRAPPER_read_only_seq wrapper_read_only;
        WRAPPER_write_read_seq wrapper_write_read;

        function new (string name = "WRAPPER_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //ENV Creation
            wrapper_env = WRAPPER_env::type_id::create("wrapper_env",this);
            slave_env = SPI_slave_env::type_id::create("slave_env",this);
            ram_env = RAM_env::type_id::create("ram_env",this);
        
            //Config Obj Creation
            wrapper_cfg = WRAPPER_config::type_id::create("wrapper_cfg", this);
            slave_cfg = SPI_slave_config::type_id::create("slave_cfg", this);
            ram_cfg = RAM_config::type_id::create("ram_cfg", this);

            //Sequences Creation
            wrapper_reset = WRAPPER_reset_seq::type_id::create("wrapper_reset");
            wrapper_write_only = WRAPPER_write_only_seq::type_id::create("wrapper_write_only");
            wrapper_read_only = WRAPPER_read_only_seq::type_id::create("wrapper_read_only");
            wrapper_write_read = WRAPPER_write_read_seq::type_id::create("wrapper_write_read");

            wrapper_cfg.is_active = UVM_ACTIVE;
            if (!uvm_config_db #(virtual WRAPPER_IF)::get(this,"","WRAPPER_IF",wrapper_cfg.wrapper_if))
                `uvm_fatal("build_phase", "Error - Test cannot retrieve the WRAPPER interface");
            uvm_config_db #(WRAPPER_config)::set(this, "*", "CFG_WRAPPER", wrapper_cfg);

            slave_cfg.is_active = UVM_PASSIVE;
            if (!uvm_config_db #(virtual SPI_slave_if)::get(this,"","SLAVE_IF",slave_cfg.slave_if))
                `uvm_fatal("build_phase", "Error - Test cannot retrieve the SLAVE interface");
            uvm_config_db #(SPI_slave_config)::set(this, "*", "CFG_SLAVE", slave_cfg);

            ram_cfg.is_active = UVM_PASSIVE;
            if (!uvm_config_db #(virtual RAM_IF)::get(this,"","RAM_IF",ram_cfg.ram_if))
                `uvm_fatal("build_phase", "Error - Test cannot retrieve the RAM interface");
            uvm_config_db #(RAM_config)::set(this, "*", "CFG_RAM", ram_cfg);

        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);

            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            wrapper_reset.start(wrapper_env.wrapper_agt.wrapper_sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

            `uvm_info("run_phase", "Write Only Seq Started", UVM_LOW);
            wrapper_write_only.start(wrapper_env.wrapper_agt.wrapper_sqr);
            `uvm_info("run_phase", "Write Only Seq Ended", UVM_LOW);
            
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            wrapper_reset.start(wrapper_env.wrapper_agt.wrapper_sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

            `uvm_info("run_phase", "Read Only Seq Started", UVM_LOW);
            is_readOnly = 1;
            wrapper_read_only.start(wrapper_env.wrapper_agt.wrapper_sqr);
            is_readOnly = 0;
            `uvm_info("run_phase", "Read Only Seq Ended", UVM_LOW);
            
            `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
            wrapper_reset.start(wrapper_env.wrapper_agt.wrapper_sqr);
            `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

            `uvm_info("run_phase", "Write Read Seq Started", UVM_LOW);
            wrapper_write_read.start(wrapper_env.wrapper_agt.wrapper_sqr);
            `uvm_info("run_phase", "Write Read Seq Ended", UVM_LOW);

            phase.drop_objection(this);
        endtask
    endclass
endpackage