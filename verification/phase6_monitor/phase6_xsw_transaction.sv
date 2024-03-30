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
        rand bit [15:0] port_addr;  // should pob be [7:0]
        bit [7:0] fifo_empty;
        bit [7:0] fifo_full;
        bit [7:0] fifo_ae;
        bit [7:0] fifo_af;

        function new(string name = "");
            super.new(name);
        endfunction

        function string toString;
            return $psprintf("----------transaction------------\n XSWITCH INPUTS:\n reset = %0d\n  addr_in = %0h data_in = %0d\n wr_en = %0d\n rd_en = %0d\n port_en = %0d\n port_wr = %0d\n port_sel = %0d\n port_addr = %0d\n XSWITCH OUTPUTS:\n data_rcv = %0d\n  addr_out = %0h data_out = %0d\n data_rdy = %0d\n fifo_empty = %0d\n fifo_full = %0d\n fifo_ae = %0d\n fifo_af = %0d", reset, addr_in, data_in, wr_en, rd_en, port_en, port_wr, port_sel, port_addr, data_rcv, addr_out, data_out, data_rdy, fifo_empty, fifo_full, fifo_ae, fifo_af);
        endfunction
    endclass

endpackage
