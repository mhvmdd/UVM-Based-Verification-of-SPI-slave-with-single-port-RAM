package SPI_slave_agent_pkg;
import SPI_slave_seq_item_pkg::*;
import SPI_slave_driver_pkg::*;
import SPI_slave_monitor_pkg::*;
import SPI_slave_sequencer_pkg::*;
import SPI_slave_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class SPI_slave_agent extends uvm_agent;
    `uvm_component_utils(SPI_slave_agent);

    SPI_slave_driver driver;
    SPI_slave_monitor monitor;
    SPI_slave_sequencer sqr;
    SPI_slave_config slave_cfg;
    uvm_analysis_port #(SPI_slave_seq_item) agt_ap;

    function  new(string name = "SPI_slave_agent" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(SPI_slave_config)::get(this,"","CFG_SLAVE",slave_cfg))
            `uvm_fatal("build_phase","Agent - unable to get configuration object");  
        
        if(slave_cfg.is_active == UVM_ACTIVE) begin
            driver = SPI_slave_driver::type_id::create("driver",this);
            sqr = SPI_slave_sequencer::type_id::create("sqr",this);  
        end
        monitor = SPI_slave_monitor::type_id::create("monitor",this);
        agt_ap = new("agt_ap",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(slave_cfg.is_active == UVM_ACTIVE) begin
            driver.slave_if = slave_cfg.slave_if;
            driver.seq_item_port.connect(sqr.seq_item_export);          
        end
        monitor.slave_if = slave_cfg.slave_if;
        monitor.mon_ap.connect(agt_ap);
    endfunction

endclass
endpackage