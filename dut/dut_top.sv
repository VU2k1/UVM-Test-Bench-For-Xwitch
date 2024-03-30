module dut_top(interface dut_xsw_upstream, interface dut_xsw_downstream);
    import uvm_pkg::*;

    // Used for Connection testing
    // always @(posedge dut_xsw.clk)
    // begin
    //     `uvm_info("DUT-Receive", $psprintf("DUT received the following:\n 
    //     reset = %d \n 
    //     addr_in = %d \n 
    //     data_in = %d \n 
    //     data_rcv = %d \n 
    //     wr_en = %d \n 
    //     addr_out = %d \n 
    //     data_out = %d \n 
    //     data_rdy = %d \n
    //     rd_en = %d \n
    //     port_en = %d \n
    //     port_wr = %d \n
    //     port_sel = %d \n
    //     port_addr = %d \n
    //     fifo_empty = %d \n
    //     fifo_full = %d \n
    //     fifo_ae = %d \n
    //     fifo_af = %d",
    //     dut_xsw.reset, dut_xsw.addr_in, dut_xsw.data_in, dut_xsw.data_rcv, dut_xsw.wr_en, 
    //     dut_xsw.addr_out, dut_xsw.data_out, dut_xsw.data_rdy,dut_xsw.rd_en, dut_xsw.port_en, 
    //     dut_xsw.port_wr, dut_xsw.port_sel, dut_xsw.port_addr, dut_xsw.fifo_empty, dut_xsw.fifo_full, 
    //     dut_xsw.fifo_ae, dut_xsw.fifo_af), UVM_NONE);
    // end

    xswitch xsw(
        .clk (dut_xsw_upstream.clk),
        .reset (dut_xsw_upstream.reset),
        .addr_in (dut_xsw_upstream.addr_in),
        .data_in (dut_xsw_upstream.data_in),
        .data_rcv (dut_xsw_downstream.data_rcv), 
        .wr_en (dut_xsw_upstream.wr_en),
        .addr_out (dut_xsw_downstream.addr_out),
        .data_out (dut_xsw_downstream.data_out),
        .data_rdy (dut_xsw_downstream.data_rdy), 
        .rd_en (dut_xsw_upstream.rd_en),
        .port_en (dut_xsw_upstream.port_en), 
        .port_wr (dut_xsw_upstream.port_wr),
        .port_sel (dut_xsw_upstream.port_sel), 
        .port_addr (dut_xsw_upstream.port_addr),
        .fifo_empty (dut_xsw_downstream.fifo_empty), 
        .fifo_full (dut_xsw_downstream.fifo_full),
        .fifo_ae (dut_xsw_downstream.fifo_ae), 
        .fifo_af (dut_xsw_downstream.fifo_af) 
        );

endmodule