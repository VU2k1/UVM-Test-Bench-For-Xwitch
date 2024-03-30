`include "uvm_macros.svh"
import uvm_pkg::*;

class xsw_monitor extends uvm_monitor;
    `uvm_component_utils(xsw_monitor)

    uvm_analysis_port #(transaction) port_up;
    uvm_analysis_port #(transaction) port_down;

    dut_config xsw_config;
    virtual intf_xsw_upstream vintf_up;
    virtual intf_xsw_downstream vintf_down;

    // 0 = Upstream, 1 = Downstream
    int control;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        xsw_config = dut_config::type_id::create("xsw_config");
        port_up = new("port_up", this);
        port_down = new("port_down", this);
        assert(uvm_config_db #(dut_config)::get(this, "", "dut_config", xsw_config));
        
        vintf_up = xsw_config.vintf_up_mon;
        vintf_down = xsw_config.vintf_down_mon;
    endfunction

    task run_phase(uvm_phase phase);
        // if (control == 0) begin
        //     repeat (4) @ (posedge vintf_up.clk);
        // end 
        // else if (control == 1) begin
        //     repeat (3) @ (posedge vintf_up.clk);
        // end
 
        forever begin
            transaction tx;
            tx = transaction::type_id::create("tx");
            
            @ (posedge vintf_up.clk)

            if (control == 0) begin
                tx.reset = vintf_up.reset;
                tx.addr_in = vintf_up.addr_in;
                tx.data_in = vintf_up.data_in; 
                tx.wr_en = vintf_up.wr_en;
                tx.rd_en = vintf_up.rd_en;
                tx.port_en = vintf_up.port_en; 
                tx.port_wr = vintf_up.port_wr;
                tx.port_sel = vintf_up.port_sel; 
                tx.port_addr = vintf_up.port_addr;
                port_up.write(tx);
            end else if (control == 1) begin
                tx.data_rcv = vintf_down.data_rcv; 
                tx.addr_out = vintf_down.addr_out;
                tx.data_out = vintf_down.data_out;
                tx.data_rdy = vintf_down.data_rdy; 
                tx.fifo_empty = vintf_down.fifo_empty; 
                tx.fifo_full = vintf_down.fifo_full;
                tx.fifo_ae = vintf_down.fifo_ae;
                tx.fifo_af = vintf_down.fifo_af;
                port_down.write(tx);
            end
        end
    endtask
endclass