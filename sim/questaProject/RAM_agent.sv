package RAM_agent_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import RAM_sequencer_pkg::*;
    import RAM_monitor_pkg::*;
    import RAM_driver_pkg::*;
    import RAM_seq_item_pkg::*;
    import RAM_config_pkg::*;
    class RAM_agent extends uvm_agent;
        `uvm_component_utils(RAM_agent)

        RAM_config ram_cfg;

        RAM_sequencer ram_sqr;
        RAM_monitor ram_mon;
        RAM_driver ram_dvr;

        uvm_analysis_port #(RAM_seq_item) agt_ap;

        function new (string name = "RAM_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if (!uvm_config_db #(RAM_config)::get(this,"","CFG_RAM",ram_cfg))
                `uvm_fatal("build_phase", "Error - Agent cannot retrieve the config object");

            ram_mon = RAM_monitor::type_id::create("ram_mon", this);

            if (ram_cfg.is_active == UVM_ACTIVE) begin
                ram_dvr = RAM_driver::type_id::create("ram_dvr", this);
                ram_sqr = RAM_sequencer::type_id::create("ram_sqr", this);
            end

            agt_ap = new ("agt_ap", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            if(ram_cfg.is_active == UVM_ACTIVE) begin
                ram_dvr.ram_dvr_if = ram_cfg.ram_if;
                ram_dvr.seq_item_port.connect(ram_sqr.seq_item_export);
            end
            ram_mon.ram_mon_if = ram_cfg.ram_if;
            ram_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage