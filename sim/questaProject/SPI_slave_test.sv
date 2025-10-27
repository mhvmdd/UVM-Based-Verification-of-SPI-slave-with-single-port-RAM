package SPI_slave_test_pkg;
import SPI_slave_env_pkg::*;
import SPI_slave_config_pkg::*;
import SPI_slave_reset_sequence_pkg::*;
import SPI_slave_main_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_test extends uvm_test;
    `uvm_component_utils(SPI_slave_test)
    SPI_slave_env env;
    SPI_slave_config slave_cfg;
    SPI_slave_reset_sequence rst_seq;
    SPI_slave_main_sequence main_seq;
    

    function new(string name = "SPI_slave_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        env = SPI_slave_env::type_id::create("env", this);
        slave_cfg = SPI_slave_config::type_id::create("slave_cfg");
        rst_seq = SPI_slave_reset_sequence::type_id::create("rst_seq");
        main_seq = SPI_slave_main_sequence::type_id::create("main_seq");

        if (!uvm_config_db #(virtual SPI_slave_if)::get(this, "", "SLAVE_IF", slave_cfg.slave_if))
            `uvm_fatal("build_phase", "Test-unable to get the virtual interface of the slave from the uvm_config_db")
        
        slave_cfg.is_active = UVM_ACTIVE;

        uvm_config_db #(SPI_slave_config)::set(this, "*", "CFG_SLAVE", slave_cfg);
    endfunction : build_phase

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);

        `uvm_info("run_phase", "Reset Asserted", UVM_LOW);
        rst_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Reset Deasserted", UVM_LOW);

        `uvm_info("run_phase", "Main Sequence Started", UVM_LOW);
        main_seq.start(env.agt.sqr);
        `uvm_info("run_phase", "Main Sequence Ended", UVM_LOW);

        phase.drop_objection(this);
    endtask
endclass
endpackage