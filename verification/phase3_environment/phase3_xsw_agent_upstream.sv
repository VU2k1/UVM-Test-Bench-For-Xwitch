`include "uvm_macros.svh"
import uvm_pkg::*;

// Sends inputs to the DUT
class xsw_agent_upstream extends uvm_agent;
    `uvm_component_utils(xsw_agent_upstream)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
