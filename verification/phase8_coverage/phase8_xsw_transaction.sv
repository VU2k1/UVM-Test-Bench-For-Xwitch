package xsw_transaction;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    class transaction extends uvm_sequence_item;
        `uvm_object_utils(transaction)

        bit reset;
        rand bit [63:0] addr_in;
        rand bit [63:0] data_in;
        bit [7:0] data_rcv; 
        rand bit [7:0] wr_en;
        bit [63:0] addr_out;
        bit [63:0] data_out;
        bit [7:0] data_rdy; 
        rand bit [7:0] rd_en;
        rand bit port_en;
        rand bit port_wr;
        rand bit [7:0] port_sel;
        rand bit [15:0] port_addr;
        bit [7:0] fifo_empty;
        bit [7:0] fifo_full;
        bit [7:0] fifo_ae;
        bit [7:0] fifo_af;

        function new(string name = "");
            super.new(name);
        endfunction
    endclass

endpackage
