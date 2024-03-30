package xsw_test_pkg;
    `include "uvm_macros.svh"
    `include "phase7_xsw_dut_config.sv"
    `include "phase7_xsw_driver.sv"
    `include "phase7_xsw_monitor.sv"
    `include "phase7_xsw_sequencer.sv"
    `include "phase7_xsw_agent_upstream.sv"
    `include "phase7_xsw_agent_downstream.sv"
    `include "phase7_xsw_scoreboard.sv"
    `include "phase7_xsw_environment.sv"
    import xsw_sequences::*;
    import uvm_pkg::*;

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

            if(!uvm_config_db #(virtual intf_xsw_upstream)::get(this, "", "vi_intf_upstream_driv", xsw_config.vintf_up_driv))
                `uvm_fatal("TEST", "No DUT FOR UPSTREAM DRIVER");

            if(!uvm_config_db #(virtual intf_xsw_upstream)::get(this, "", "vi_intf_upstream_mon", xsw_config.vintf_up_mon))
                `uvm_fatal("TEST", "No DUT FOR UPSTREAM MONITOR");
            
            if(!uvm_config_db #(virtual intf_xsw_downstream)::get(this, "", "vi_intf_downstream", xsw_config.vintf_down_mon))
                `uvm_fatal("TEST", "No DUT FOR DOWNSTREAM MONITOR");

            // other DUT configuration settings
            uvm_config_db#(dut_config)::set(this, "*", "dut_config", xsw_config);
        endfunction
    endclass

    class testcase extends xsw_test;
        `uvm_component_utils(testcase)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

    class test_scoreboard extends xsw_test;
        `uvm_component_utils(test_scoreboard)
        
        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
        
        task run_phase(uvm_phase phase);
            xsw_write_read_sequence seq;
            seq = xsw_write_read_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass
endpackage
