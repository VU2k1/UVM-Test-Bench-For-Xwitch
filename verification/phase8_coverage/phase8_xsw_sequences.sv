package xsw_sequences;
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import xsw_transaction::*;

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

        constraint amount{n inside {[10:20]};}

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
    // ---------------------------------------------------------------------
    // Write Xswitch
    class xsw_write extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_write)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 11;
            tx.addr_in = 64'h0004000400010004;
            tx.rd_en = 0;
            tx.port_en = 0;
            tx.port_wr = 0;
            tx.port_sel = 0;
            tx.port_addr = 0;
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

    // Configuration
    class xsw_config extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_config)

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

            // Port 0 Dummy Configs
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 0;
            tx.port_addr = 16'h0001;
            finish_item(tx);
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 0;
            tx.port_addr = 16'h0001;
            finish_item(tx); 
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

            // Port 1 Replika Config
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 1;
            tx.port_addr = 16'h0001;
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

            // Port 3 Replika Configuration 
            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 0;
            tx.port_en = 1;
            tx.port_wr = 1;
            tx.port_sel = 3;
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

    // Configuration
    class xsw_good_config extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_good_config)

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

    // Read Xswitch
    class xsw_read extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_read)

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            transaction tx;
            tx = transaction::type_id::create("tx");

            start_item(tx);
            assert(tx.randomize());
            tx.wr_en = 0;
            tx.rd_en = 13;
            tx.port_en = 0;
            tx.port_wr = 0;
            finish_item(tx);
        endtask
    endclass

    // Write and Read Sequence
    class xsw_write_read_sequence extends uvm_sequence #(transaction);
        `uvm_object_utils(xsw_write_read_sequence)
        `uvm_declare_p_sequencer(uvm_sequencer#(transaction))

        rand int n;

        // constraint amount{n inside {[10:20]};}
        constraint amount{n == 200;}

        function new(string name = "");
            super.new(name);
        endfunction

        task body;
            repeat(3) begin
                xsw_none xsw_seq;
                xsw_seq = xsw_none::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            begin
                xsw_config xsw_seq;
                xsw_seq = xsw_config::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_write xsw_seq;
                xsw_seq = xsw_write::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_read xsw_seq;
                xsw_seq = xsw_read::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end

            begin
                xsw_good_config xsw_seq;
                xsw_seq = xsw_good_config::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_write xsw_seq;
                xsw_seq = xsw_write::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_read xsw_seq;
                xsw_seq = xsw_read::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            begin
                xsw_config xsw_seq;
                xsw_seq = xsw_config::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_write xsw_seq;
                xsw_seq = xsw_write::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_read xsw_seq;
                xsw_seq = xsw_read::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_write xsw_seq;
                xsw_seq = xsw_write::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_read xsw_seq;
                xsw_seq = xsw_read::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(n) begin
                xsw_write xsw_seq;
                xsw_seq = xsw_write::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
            repeat(3) begin
                xsw_read xsw_seq;
                xsw_seq = xsw_read::type_id::create("xsw_seq");
                assert(xsw_seq.randomize());
                xsw_seq.start(p_sequencer);
            end
        endtask
    endclass
    // ---------------------------------------------------------------------

endpackage
