package WRAPPER_env_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import WRAPPER_agent_pkg::*;
    import WRAPPER_scoreboard_pkg::*;
    import WRAPPER_coverage_pkg::*;
    class WRAPPER_env extends uvm_env;
        `uvm_component_utils(WRAPPER_env)

        WRAPPER_agent wrapper_agt;
        WRAPPER_scoreboard wrapper_sb;
        WRAPPER_coverage wrapper_cvg;

        function new (string name = "WRAPPER_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            wrapper_agt = WRAPPER_agent::type_id::create("wrapper_agt", this);
            wrapper_sb= WRAPPER_scoreboard::type_id::create("wrapper_sb", this);
            wrapper_cvg = WRAPPER_coverage::type_id::create("wrapper_cvg", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            wrapper_agt.agt_ap.connect(wrapper_sb.sb_axp);
            wrapper_agt.agt_ap.connect(wrapper_cvg.cvg_axp);
        endfunction
    endclass
endpackage