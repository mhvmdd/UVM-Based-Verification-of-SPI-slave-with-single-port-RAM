package RAM_env_pkg;
    import uvm_pkg::*;
    `include"uvm_macros.svh"
    import RAM_agent_pkg::*;
    import RAM_scoreboard_pkg::*;
    import RAM_coverage_pkg::*;
    class RAM_env extends uvm_env;
        `uvm_component_utils(RAM_env)

        RAM_agent ram_agt;
        RAM_scoreboard ram_sb;
        RAM_coverage ram_cvg;

        function new (string name = "RAM_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ram_agt = RAM_agent::type_id::create("ram_agt", this);
            ram_sb= RAM_scoreboard::type_id::create("ram_sb", this);
            ram_cvg = RAM_coverage::type_id::create("ram_cvg", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            ram_agt.agt_ap.connect(ram_sb.sb_axp);
            ram_agt.agt_ap.connect(ram_cvg.cvg_axp);
        endfunction


    endclass
endpackage