`include "phase6_interface.sv"

module tbench_top;
    import uvm_pkg::*;
    import xsw_test_pkg::*;

    bit clk;
    bit reset;

    intf_xsw_upstream intf_up(clk, reset);

    intf_xsw_downstream intf_down(clk, reset);

    dut_top dut(.dut_xsw_upstream(intf_up.dut_xsw), .dut_xsw_downstream(intf_down.dut_xsw));

    // Clock Generator
    initial
    begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset Generator
    initial
    begin
        reset = 1;
        repeat(3) @(posedge clk);
        reset = 0;
    end

    // enable wave dump
    initial begin
        uvm_config_db #(virtual intf_xsw_upstream)::set(null, "uvm_test_top", "vi_intf_upstream_driv", intf_up.driv_xsw);
        uvm_config_db #(virtual intf_xsw_upstream)::set(null, "uvm_test_top", "vi_intf_upstream_mon", intf_up.mon_xsw);
        uvm_config_db #(virtual intf_xsw_downstream)::set(null, "uvm_test_top", "vi_intf_downstream", intf_down.mon_xsw);

        run_test("xsw_test");
    end

endmodule