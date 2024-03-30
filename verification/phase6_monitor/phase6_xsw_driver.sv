`include "uvm_macros.svh"
import xsw_transaction::*;
import uvm_pkg::*;

class xsw_driver extends uvm_driver #(transaction);
    `uvm_component_utils(xsw_driver)

    dut_config xsw_config;
    virtual intf_xsw_upstream vintf_up;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        assert(uvm_config_db #(dut_config):: get(this, "", "dut_config", xsw_config)); 
        vintf_up = xsw_config.vintf_up_driv;
    endfunction

    task run_phase (uvm_phase phase);
        forever
        begin
            transaction tx;
            seq_item_port.get(tx);

            //wiggle pins of DUT
            vintf_up.addr_in = tx.addr_in;
            vintf_up.data_in = tx.data_in;
            vintf_up.wr_en = tx.wr_en;
            vintf_up.rd_en = tx.rd_en;
            vintf_up.port_en = tx.port_en;
            vintf_up.port_wr = tx.port_wr;
            vintf_up.port_sel = tx.port_sel;
            vintf_up.port_addr = tx.port_addr;

        end
    endtask
endclass