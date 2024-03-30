`include "uvm_macros.svh"
`include "phase4_xsw_sequencer.sv"
import uvm_pkg::*;

// Sends inputs to the DUT
class xsw_agent_upstream extends uvm_agent;
    `uvm_component_utils(xsw_agent_upstream)

    xsw_sequencer xsw_sequencer_h;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase); 
        xsw_sequencer_h = xsw_sequencer::type_id::create("xsw_sequencer_h", this);
    endfunction
endclass
