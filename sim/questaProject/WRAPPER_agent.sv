package WRAPPER_agent_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_sequencer_pkg::*;
    import WRAPPER_monitor_pkg::*;
    import WRAPPER_driver_pkg::*;
    import WRAPPER_seq_item_pkg::*;
    import WRAPPER_config_pkg::*;
    class WRAPPER_agent extends uvm_agent;
        `uvm_component_utils(WRAPPER_agent)

        WRAPPER_config wrapper_cfg;

        WRAPPER_sequencer wrapper_sqr;
        WRAPPER_monitor wrapper_mon;
        WRAPPER_driver wrapper_dvr;

        uvm_analysis_port #(WRAPPER_seq_item) agt_ap;

        function new (string name = "WRAPPER_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db #(WRAPPER_config)::get(this,"","CFG_WRAPPER",wrapper_cfg))
                `uvm_fatal("build_phase", "Error - Wrapper Agent cannot retrieve the config object");

            wrapper_mon = WRAPPER_monitor::type_id::create("wrapper_mon", this);

            if (wrapper_cfg.is_active == UVM_ACTIVE) begin
                wrapper_dvr = WRAPPER_driver::type_id::create("wrapper_dvr", this);
                wrapper_sqr = WRAPPER_sequencer::type_id::create("wrapper_sqr", this);
            end

            agt_ap = new ("agt_ap", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            if(wrapper_cfg.is_active == UVM_ACTIVE) begin
                wrapper_dvr.wrapper_dvr_if = wrapper_cfg.wrapper_if;
                wrapper_dvr.seq_item_port.connect(wrapper_sqr.seq_item_export);
            end
            wrapper_mon.wrapper_mon_if = wrapper_cfg.wrapper_if;
            wrapper_mon.mon_ap.connect(agt_ap);
        endfunction
    endclass
endpackage