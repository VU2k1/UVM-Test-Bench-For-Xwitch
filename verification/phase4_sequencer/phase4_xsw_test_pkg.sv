package xsw_test_pkg;
    `include "uvm_macros.svh"
    `include "phase4_xsw_agent_upstream.sv"
    `include "phase4_xsw_agent_downstream.sv"
    `include "phase4_xsw_environment.sv"
    import xsw_sequences::*;
    import uvm_pkg::*;

    class dut_config extends uvm_object;
        `uvm_object_utils(dut_config)

        virtual intf_xsw_upstream vintf_up;

        virtual intf_xsw_downstream vintf_down;

        function new(string name = "");
            super.new(name);
        endfunction
    endclass 

    class xsw_test extends uvm_test;
        `uvm_component_utils(xsw_test)

        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            xsw_config = new();

            if(!uvm_config_db #(virtual intf_xsw_upstream)::get(this, "", "vi_intf_upstream", xsw_config.vintf_up))
                `uvm_fatal("TEST", "No DUT FOR UPSTREAM");
            
            if(!uvm_config_db #(virtual intf_xsw_downstream)::get(this, "", "vi_intf_downstream", xsw_config.vintf_down))
                `uvm_fatal("TEST", "No DUT FOR DOWNSTREAM");

            // other DUT configuration settings
            uvm_config_db#(dut_config)::set(this, "*", "dut_config", xsw_config);
        endfunction
    endclass

endpackage
