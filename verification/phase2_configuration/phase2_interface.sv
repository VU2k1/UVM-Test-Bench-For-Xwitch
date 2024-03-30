`ifndef _INTERFACE_UPSTREAM_
`define _INTERFACE_UPSTREAM_

interface intf_xsw_upstream(input logic clk, reset);
    logic [63:0] addr_in;
    logic [63:0] data_in;
    logic [7:0] data_rcv; 
    logic [7:0] wr_en;
    logic [63:0] addr_out;
    logic [63:0] data_out;
    logic [7:0] data_rdy;
    logic [7:0] rd_en;
    logic port_en; 
    logic port_wr;
    logic [7:0] port_sel; 
    logic [15:0] port_addr;
    logic [7:0] fifo_empty; 
    logic [7:0] fifo_full;
    logic [7:0] fifo_ae;
    logic [7:0] fifo_af;

clocking driver_cb @(posedge clk);
    output addr_in;
    output data_in;
    output wr_en;
    output rd_en;
    output port_en; 
    output port_wr;
    output port_sel; 
    output port_addr;
endclocking

clocking monitor_cb @(posedge clk);
    input addr_in;
    input data_in; 
    input wr_en;
    input rd_en;
    input port_en; 
    input port_wr;
    input port_sel; 
    input port_addr;
endclocking

modport dut_xsw(
    input clk,
    input reset,
    input addr_in,
    input data_in, 
    input wr_en,
    input rd_en,
    input port_en, 
    input port_wr,
    input port_sel, 
    input port_addr
);

modport driv_xsw(
    clocking driver_cb,
    input clk,
    input reset
);

modport mon_xsw(
    clocking monitor_cb,
    input clk,
    input reset
);

endinterface

`endif

`ifndef _INTERFACE_DOWNSTREAM_
`define _INTERFACE_DOWNSTREAM_

interface intf_xsw_downstream(input logic clk, reset);
    logic [63:0] addr_in;
    logic [63:0] data_in;
    logic [7:0] data_rcv; 
    logic [7:0] wr_en;
    logic [63:0] addr_out;
    logic [63:0] data_out;
    logic [7:0] data_rdy;
    logic [7:0] rd_en;
    logic port_en; 
    logic port_wr;
    logic [7:0] port_sel; 
    logic [15:0] port_addr;
    logic [7:0] fifo_empty; 
    logic [7:0] fifo_full;
    logic [7:0] fifo_ae;
    logic [7:0] fifo_af;

clocking monitor_cb @(posedge clk);
    input data_rcv; 
    input addr_out;
    input data_out;
    input data_rdy; 
    input fifo_empty; 
    input fifo_full;
    input fifo_ae;
    input fifo_af;
endclocking

modport dut_xsw(
    output data_rcv, 
    output addr_out,
    output data_out,
    output data_rdy, 
    output fifo_empty, 
    output fifo_full,
    output fifo_ae,
    output fifo_af
);

modport mon_xsw(clocking monitor_cb);

endinterface

`endif
