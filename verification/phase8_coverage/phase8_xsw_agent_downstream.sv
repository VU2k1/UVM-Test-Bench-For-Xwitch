`include "uvm_macros.svh"
import uvm_pkg::*;

// Gets inputs to the DUT
class xsw_agent_downstream extends uvm_agent;
    `uvm_component_utils(xsw_agent_downstream)
    
    uvm_analysis_port #(transaction) port_down;

    xsw_monitor xsw_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase); 
        port_down = new("port_down", this);
        xsw_monitor_h = xsw_monitor::type_id::create("xsw_monitor_h", this);
        xsw_monitor_h.control = 1;
    endfunction

    function void connect_phase(uvm_phase phase);
        xsw_monitor_h.port_down.connect(port_down);
    endfunction: connect_phase

endclass