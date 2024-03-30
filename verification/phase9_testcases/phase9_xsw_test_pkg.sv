`ifndef _XSWITCH__TEST_
`define _XSWITCH_TEST_

package xsw_test_pkg;
    `include "uvm_macros.svh"
    `include "phase9_xsw_dut_config.sv"
    `include "phase9_xsw_driver.sv"
    `include "phase9_xsw_monitor.sv"
    `include "phase9_xsw_sequencer.sv"
    `include "phase9_xsw_agent_upstream.sv"
    `include "phase9_xsw_agent_downstream.sv"
    `include "phase9_xsw_scoreboard.sv"
    `include "phase9_xsw_environment.sv"
    import xsw_sequences::*;
    import uvm_pkg::*;

/*************************************************************SANITY TEST****************************************************************************/

    class sanity_test extends uvm_test;
        `uvm_component_utils(sanity_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_sanity::get_type());
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

        task run_phase(uvm_phase phase);                          
            sanity_test_sequence seq;
            seq = sanity_test_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*************************************************************RESET TEST****************************************************************************/

    class reset_test extends uvm_test;
        `uvm_component_utils(reset_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_reset::get_type());
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

        task run_phase(uvm_phase phase);                          
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************VALID CONFIG TEST****************************************************************************/

    class valid_config_test extends uvm_test;
        `uvm_component_utils(valid_config_test)
        
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

        task run_phase(uvm_phase phase);                          
            sanity_test_sequence seq;
            seq = sanity_test_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************REPEAT CONFIG TEST****************************************************************************/

    class repeat_config_test extends uvm_test;
        `uvm_component_utils(repeat_config_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_config_repeat::get_type());
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

        task run_phase(uvm_phase phase);                          
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************NONE UNIQUE CONFIG TEST****************************************************************************/

    class none_unique_config_test extends uvm_test;
        `uvm_component_utils(none_unique_config_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_config_non_unique::get_type());
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

        task run_phase(uvm_phase phase);                          
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************RANDOM CONFIG TEST****************************************************************************/

    class random_config_test extends uvm_test;
        `uvm_component_utils(random_config_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_random_config::get_type());
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

        task run_phase(uvm_phase phase);                          
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************RECIEVE OFF TEST****************************************************************************/
 class rcv_off_test extends uvm_test;
        `uvm_component_utils(rcv_off_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_rcv_off::get_type());
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

        task run_phase(uvm_phase phase);                          
            xsw_random_sequence seq;
            seq = xsw_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************WRITE FULL TEST****************************************************************************/
    class write_full_test extends uvm_test;
        `uvm_component_utils(write_full_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_write_full::get_type());
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

        task run_phase(uvm_phase phase);                          
            write_full_test_sequence seq;
            seq = write_full_test_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************WRITE RANDOM TEST****************************************************************************/
    class write_random_test extends uvm_test;
        `uvm_component_utils(write_random_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_write_random::get_type());
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

        task run_phase(uvm_phase phase);                          
            write_random_sequence seq;
            seq = write_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

/*********************************************************INPUT ADDRESS TEST****************************************************************************/
    class addr_in_test extends uvm_test;
        `uvm_component_utils(addr_in_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_write_random::get_type());
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

        task run_phase(uvm_phase phase);                          
            address_in_sequence seq;
            seq = address_in_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

    /*********************************************************READY OFF TEST****************************************************************************/
    class rdy_off_test extends uvm_test;
        `uvm_component_utils(rdy_off_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_rdy_off::get_type());
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

        task run_phase(uvm_phase phase);                          
            rdy_off_sequence seq;
            seq = rdy_off_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

    /*********************************************************READ RANDOM TEST****************************************************************************/
    class read_random_test extends uvm_test;
        `uvm_component_utils(read_random_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_read_random::get_type());
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

        task run_phase(uvm_phase phase);                          
            read_random_sequence seq;
            seq = read_random_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

    /*********************************************************READ AND WRITE TEST****************************************************************************/
    class read_and_write_test extends uvm_test;
        `uvm_component_utils(read_and_write_test)
        
        dut_config xsw_config;

        // declare environment instance
        xsw_environment xsw_env;

        function new(string name, uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            xsw_env = xsw_environment::type_id::create("xsw_env", this);
            transaction::type_id::set_type_override(transaction_read_and_write::get_type());
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

        task run_phase(uvm_phase phase);                          
            read_and_write_sequence seq;
            seq = read_and_write_sequence::type_id::create("seq");
            assert(seq.randomize());
            phase.raise_objection(this);
            seq.start(xsw_env.xsw_agent_upstream_h.xsw_sequencer_h);
            phase.drop_objection(this);
        endtask
    endclass

endpackage

`endif 