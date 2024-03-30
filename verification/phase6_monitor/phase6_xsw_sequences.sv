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

endpackage
