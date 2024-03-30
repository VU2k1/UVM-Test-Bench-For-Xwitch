`include "uvm_macros.svh"
import uvm_pkg::*;

class dut_config extends uvm_object;
    `uvm_object_utils(dut_config)

    virtual intf_xsw_upstream vintf_up_driv;
    virtual intf_xsw_upstream vintf_up_mon;
    virtual intf_xsw_downstream vintf_down_mon;

    function new(string name = "");
        super.new(name);
    endfunction
endclass 
