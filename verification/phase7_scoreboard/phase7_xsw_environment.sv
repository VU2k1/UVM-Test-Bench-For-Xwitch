`include "uvm_macros.svh"
import uvm_pkg::*;

class xsw_environment extends uvm_env;
    `uvm_component_utils(xsw_environment)

    UVM_FILE file_h;
    xsw_agent_upstream xsw_agent_upstream_h;
    xsw_agent_downstream xsw_agent_downstream_h;
    xsw_scoreboard xsw_scoreboard_h;

    // constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        xsw_agent_upstream_h = xsw_agent_upstream::type_id::create("xsw_agent_upstream_h", this);
        xsw_agent_downstream_h = xsw_agent_downstream::type_id::create("xsw_agent_downstream_h", this);
        xsw_scoreboard_h = xsw_scoreboard::type_id::create("xsw_scoreboard_h", this);
    endfunction 

    function void connect_phase(uvm_phase phase);
        xsw_agent_downstream_h.port_down.connect(xsw_scoreboard_h.port_down);
        xsw_agent_upstream_h.port_up.connect(xsw_scoreboard_h.port_up);
    endfunction 

    function void start_of_simulation_phase(uvm_phase phase);
        uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
        
        file_h = $fopen("CME435_xsw_project.log", "w");
        uvm_top.set_report_default_file_hier(file_h);
        uvm_top.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY + UVM_LOG);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        #10;
        phase.drop_objection(this);
    endtask
endclass