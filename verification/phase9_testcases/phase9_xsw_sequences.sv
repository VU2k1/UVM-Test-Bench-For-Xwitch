package xsw_sequences;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import xsw_transaction::*;

    // ===============================General Classes==============================
    // Manual Configuration
    class config_manual extends uvm_sequence #(transaction);
        `uvm_object_utils(config_manual)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            // Port 0 Configuration 
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 0;
            tx.port_addr = 16'h0001;
            finish_item(tx);

            // Port 1 Configuration 
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 1;
            tx.port_addr = 16'h0002;
            finish_item(tx);

            // Port 2 Configuration 
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 2;
            tx.port_addr = 16'h0003;
            finish_item(tx);

            // Port 3 Configuration 
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 3;
            tx.port_addr = 16'h0004;
            finish_item(tx);
        endtask
    endclass
    
    // No Instruction
    class xsw_none extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_none)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 0;
            tx.port_wr = 0;
            tx.port_sel = 0;
            tx.port_addr = 0;
            finish_item(tx);
        endtask
    endclass

    // ===============================Random Inputs================================
    // Random Xswitch Inputs
    class xsw_random extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_random)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            finish_item(tx);
        endtask

    endclass

     // Random Sample of Random Xswitch Inputs
    class xsw_random_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_random_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;

        constraint amount{n inside {[950:1000]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(n) begin
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass
    // ===============================Sanity Check=================================
    // Write for Sanity Check
    class write_sanity extends uvm_sequence #(transaction);
        `uvm_object_utils(write_sanity)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            tx.rd_en = 0;
            finish_item(tx);
        endtask
    endclass

     // Read for Sanity Check
    class read_sanity extends uvm_sequence #(transaction);
        `uvm_object_utils(read_sanity)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            finish_item(tx);
        endtask
    endclass
    
    class sanity_test_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(sanity_test_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[10:15]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            repeat(n) begin
                write_sanity xsw_seq;
                xsw_seq = write_sanity::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            repeat(n) begin
                read_sanity xsw_seq;
                xsw_seq = read_sanity::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask

    endclass

    // ==============================VALID CONFIG TEST====================================
    class valid_config_test_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(valid_config_test_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

     // ==============================WRITE FULL TEST====================================
    class write_full_test_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(write_full_test_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[300:350]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

    // ==============================WRITE RANDOM TEST====================================
    class write_random_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(write_random_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[50:100]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

    // ==============================INPUT ADDRESS TEST====================================
    class address_in_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(address_in_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[50:100]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

    // ==============================READY OFF TEST====================================
    class rdy_off_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(rdy_off_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[50:100]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

    // ==============================READ RANDOM TEST====================================
    class read_random_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(read_random_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[50:100]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                xsw_random xsw_seq;
                xsw_seq = xsw_random::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass

    // ==============================READ AND WRITE TEST====================================
    // Write All
    class write_all extends uvm_sequence #(transaction);
        `uvm_object_utils(write_all)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
	    tx.wr_en = 15;
            tx.rd_en = 0;
            finish_item(tx);
        endtask
    endclass

     // Read for Sanity Check
    class read_all extends uvm_sequence #(transaction);
        `uvm_object_utils(read_all)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
	    tx.rd_en = 15;
            tx.wr_en = 0;
            finish_item(tx);
        endtask
    endclass

    class read_and_write_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(read_and_write_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;
        constraint rep_amount{n inside {[280:300]};}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(1) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                config_manual xsw_seq;
                xsw_seq = config_manual::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            
            repeat(n) begin 
                write_all xsw_seq;
                xsw_seq = write_all::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

             repeat(n) begin 
                read_all xsw_seq;
                xsw_seq = read_all::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

        endtask
    endclass
endpackage
