`include "uvm_macros.svh"
import uvm_pkg::*;

// Sends inputs to the DUT
class xsw_agent_upstream extends uvm_agent;
    `uvm_component_utils(xsw_agent_upstream)

    uvm_analysis_port #(transaction) port_up;

    xsw_sequencer xsw_sequencer_h;
    xsw_driver xsw_driver_h;
    xsw_monitor xsw_monitor_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase); 
        port_up = new("port_up", this);
        xsw_sequencer_h = xsw_sequencer::type_id::create("xsw_sequencer_h", this);
        xsw_driver_h = xsw_driver::type_id::create("xsw_driver_h", this);
        xsw_monitor_h = xsw_monitor::type_id::create("xsw_monitor_h", this);
        xsw_monitor_h.control = 0;
    endfunction

    function void connect_phase(uvm_phase phase);
        xsw_driver_h.seq_item_port.connect(xsw_sequencer_h.seq_item_export);
        xsw_monitor_h.port_up.connect(port_up);
    endfunction

endclass
