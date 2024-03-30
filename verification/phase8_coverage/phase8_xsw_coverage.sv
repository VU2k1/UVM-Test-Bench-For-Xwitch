package xsw_coverage;
    `include "uvm_macros.svh"
    import xsw_transaction::*;
    import uvm_pkg::*;

    class xsw_coverage_inputs extends uvm_subscriber #(transaction);
        `uvm_component_utils(xsw_coverage_inputs)

        logic reset;
        logic [63:0] addr_in;
        logic [63:0] data_in;
        logic [7:0] wr_en;
        logic [7:0] rd_en;
        logic port_en;
        logic port_wr;
        logic [7:0] port_sel;
        logic [15:0] port_addr;

        // Reset Cover
        covergroup cg_reset;
            cp_reset : coverpoint reset {
                bins resetOn = {1};
                bins resetOff = {0};
                bins resetTrans0[] = (0=>0, 1);
                bins resetTrans1[] = (1=>0, 1);
            }
        endgroup 

        // Data_in Coverage
        covergroup cg_data_in;
            cp_data_in_1: coverpoint data_in[15:0] {
                bins data_in_max_1 = {16'hFFFF};
                bins data_in_range_1[8] = {[0:$]};
                bins data_in_min_1 = {16'h0};
            }
            cp_data_in_2: coverpoint data_in[31:16] {
                bins data_in_max_2 = {16'hFFFF};
                bins data_in_range_2[8] = {[0:$]};
                bins data_in_min_2 = {16'h0};
            }
            cp_data_in_3: coverpoint data_in[47:32] {
                bins data_in_max_3 = {16'hFFFF};
                bins data_in_range_3[8] = {[0:$]};
                bins data_in_min_3 = {16'h0};
            }
            cp_data_in_4: coverpoint data_in[63:48] {
                bins data_in_max_4 = {16'hFFFF};
                bins data_in_range_4[8] = {[0:$]};
                bins data_in_min_4 = {16'h0};
            }
        endgroup

        // Addr_in Coverage
        covergroup cg_addr_in;
            cp_addr_in_1: coverpoint addr_in[15:0] {
                bins addr_in_max_1 = {16'hFFFF};
                bins addr_in_range_1[8] = {[0:$]};
                bins addr_in_min_1 = {16'h0};
            }
            cp_addr_in_2: coverpoint addr_in[31:16] {
                bins addr_in_max_2 = {16'hFFFF};
                bins addr_in_range_2[8] = {[0:$]};
                bins addr_in_min_2 = {16'h0};
            }
            cp_addr_in_3: coverpoint addr_in[47:32] {
                bins addr_in_max_3 = {16'hFFFF};
                bins addr_in_range_3[8] = {[0:$]};
                bins addr_in_min_3 = {16'h0};
            }
            cp_addr_in_4: coverpoint addr_in[63:48] {
                bins addr_in_max_4 = {16'hFFFF};
                bins addr_in_range_4[8] = {[0:$]};
                bins addr_in_min_4 = {16'h0};
            }
        endgroup   

        // Data Enables
        covergroup cg_data_input_indicators;
            coverpoint wr_en {
            bins cp_wr_en[] = {[0:15]};
            }
            coverpoint rd_en {
                bins cp_rd_en[] = {[0:15]};
            }
        endgroup

        // Toggle Coverage for wr_en
        covergroup cg_wr_en_toggle with function sample(int bit_num, bit bit_val);
            coverpoint wr_en {
                bins full_cover[] = {[0:15]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:3]};
            }
            cp_a_toggle : cross bit_num, bit_val, wr_en;
        endgroup

        function void cov_wr_en_toggles(bit [3:0] value);
            for (int a=0; a < 4; a++) begin
                cg_wr_en_toggle.sample(a, value[a]);
            end
        endfunction
        
        // Toggle Coverage for rd_en 
        covergroup cg_rd_en_toggle with function sample(int bit_num, bit bit_val);
            coverpoint rd_en  {
                bins full_cover[] = {[0:15]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:3]};
            }
            cp_a_toggle : cross bit_num, bit_val, rd_en ;
        endgroup

        function void cov_rd_en_toggles(bit [3:0] value);
            for (int a=0; a < 4; a++) begin
                cg_rd_en_toggle.sample(a, value[a]);
            end
        endfunction

        // Coverage for Port Configurations.
        covergroup cg_config;
            port_enable: coverpoint port_en {
                bins cp_port_en_0 = {0};
                bins cp_port_en_1 = {1};
                bins cp_port_en_trans_0 = (0=>0,1);
                bins cp_port_en_trans_1 = (1=>0,1);
            }
            port_write: coverpoint port_wr {
                bins cp_port_wr_0 = {0};
                bins cp_port_wr_1 = {1};
                bins cp_port_wr_trans_0 = (0=>0,1);
                bins cp_port_wr_trans_1 = (1=>0,1);
            }
            port_select: coverpoint port_sel {
                bins sel_port_0 = {0};
                bins sel_port_1 = {1};
                bins sel_port_2 = {2};
                bins sel_port_3 = {3};
            }
            port_sel_0_toggle: coverpoint port_sel[0] {
                bins cp_port_sel_0_trans_0 = (0=>0,1);
                bins cp_port_sel_0_trans_1 = (1=>0,1);
            }
            port_sel_1_toggle: coverpoint port_sel[1] {
                bins cp_port_sel_1_trans_0 = (0=>0,1);
                bins cp_port_sel_1_trans_1 = (1=>0,1);
            }
            port_address: coverpoint port_addr {
                bins port_addr_min = {0};
                bins addr_in_range[8] = {[0:$]};
                bins port_addr_max = {255};
            }
        endgroup 

        // Constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);
            reset = 0;
            addr_in = 0;
            data_in = 0;
            wr_en = 0;
            rd_en = 0;
            port_en = 0;
            port_wr = 0;
            port_sel = 0;
            port_addr = 0;

            // Coverage Initializations
            cg_reset = new();
            cg_addr_in = new();
            cg_config = new();
            cg_data_in = new();
            cg_data_input_indicators = new();
            cg_rd_en_toggle =new();
            cg_wr_en_toggle = new();
        
            
        endfunction

        // Write Function from the upstream
        function void write(transaction t);
            this.reset = t.reset;
            this.addr_in = t.addr_in;
            this.data_in = t.data_in;
            this.wr_en = t.wr_en;
            this.rd_en = t.rd_en;
            this.port_en = t.port_en;
            this.port_wr = t.port_wr;
            this.port_sel = t.port_sel;
            this.port_addr = t.port_addr;
            sample_all();
        endfunction

         

        // Function used to sample all covergroups in the Coverage
        function void sample_all();
            // Covergroup samples
            cg_reset.sample();
            cg_data_in.sample();
            cg_addr_in.sample();
            cg_data_input_indicators.sample();
            cg_config.sample();


     
            // Toggle samples
            cov_wr_en_toggles(wr_en);
            cov_rd_en_toggles(rd_en);
        endfunction
    endclass

    class xsw_coverage_outputs extends uvm_subscriber #(transaction);
        `uvm_component_utils(xsw_coverage_outputs)
        
        logic [63:0] addr_out;
        logic [63:0] data_out;
        logic [7:0] data_rcv;
        logic [7:0] data_rdy; 
        logic [7:0] fifo_empty;
        logic [7:0] fifo_full;
        logic [7:0] fifo_ae;
        logic [7:0] fifo_af;
        
        // Covegroup for FIFO indicators
        covergroup cg_fifo;
            cp_fifo_empty_0: coverpoint fifo_empty[3:0] {
                bins empty_max = {15};
                bins empty[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_empty_1: coverpoint fifo_empty[7:4] {
                bins empty_max = {15};
                bins empty[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_full_0: coverpoint fifo_full[3:0] {
                bins empty_max = {15};
                bins full[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_full_1: coverpoint fifo_full[7:4] {
                bins empty_max = {15};
                bins full[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_almost_empty_0: coverpoint fifo_ae [3:0] {
                bins empty_max = {15};
                bins empty[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_almost_empty_1: coverpoint fifo_ae [7:4] {
                bins empty_max = {15};
                bins empty[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_almost_full_0: coverpoint fifo_af[3:0] {
                bins empty_max = {15};
                bins full[] = {[0:$]};
                bins empty_min = {0};
            }
            cp_fifo_almost_full_1: coverpoint fifo_af[7:4] {
                bins empty_max = {15};
                bins full[] = {[0:$]};
                bins empty_min = {0};
            }
        endgroup

        // Toggle Coverage for fifo_empty
        covergroup cg_fifo_empty_toggle with function sample(int bit_num, bit bit_val);
            coverpoint fifo_empty {
                bins empty_cover[] = {[0:$]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:7]};
            }
            cp_a_toggle : cross bit_num, bit_val, fifo_empty;
        endgroup

        function void cov_fifo_empty_toggles(bit [7:0] value);
            for (int a=0; a < 8; a++) begin
                cg_fifo_empty_toggle.sample(a, value[a]);
            end
        endfunction
        
        // Toggle Coverage for fifo_ae
        covergroup cg_fifo_almost_empty_toggle with function sample(int bit_num, bit bit_val);
            coverpoint fifo_ae {
                bins almost_empty_cover[] = {[0:$]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:7]};
            }
            cp_a_toggle : cross bit_num, bit_val, fifo_ae;
        endgroup

        function void cov_fifo_almost_empty_toggles(bit [7:0] value);
            for (int a=0; a < 8; a++) begin
                cg_fifo_almost_empty_toggle.sample(a, value[a]);
            end
        endfunction

        // Toggle Coverage for fifo_af
        covergroup cg_fifo_almost_full_toggle with function sample(int bit_num, bit bit_val);
            coverpoint fifo_af {
                bins almost_full_cover[] = {[0:$]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:7]};
            }
            cp_a_toggle : cross bit_num, bit_val, fifo_af;
        endgroup

        function void cov_fifo_almost_full_toggles(bit [7:0] value);
            for (int a=0; a < 8; a++) begin
                cg_fifo_almost_full_toggle.sample(a, value[a]);
            end
        endfunction

        // Toggle Coverage for fifo_full 
        covergroup cg_fifo_full_toggle with function sample(int bit_num, bit bit_val);
            coverpoint fifo_full {
                bins full_cover[] = {[0:$]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:7]};
            }
            cp_a_toggle : cross bit_num, bit_val, fifo_full;
        endgroup

        function void cov_fifo_full_toggles(bit [7:0] value);
            for (int a=0; a < 8; a++) begin
                cg_fifo_full_toggle.sample(a, value[a]);
            end
        endfunction

        // Data Output Indicators
        covergroup cg_data_output_indicators;
            coverpoint data_rcv {
                bins cp_data_rcv[] = {[0:15]};
            }
            coverpoint data_rdy {
                bins cp_data_rdy[] = {[0:15]};
            }
        endgroup

        // Toggle Coverage for data_rcv
        covergroup cg_data_rcv_toggle with function sample(int bit_num, bit bit_val);
            coverpoint data_rcv {
                bins full_cover[] = {[0:15]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:3]};
            }
            cp_a_toggle : cross bit_num, bit_val, data_rcv;
        endgroup

        function void cov_data_rcv_toggles(bit [3:0] value);
            for (int a=0; a < 4; a++) begin
                cg_data_rcv_toggle.sample(a, value[a]);
            end
        endfunction
        
        // Toggle Coverage for data_rdy 
        covergroup cg_data_rdy_toggle with function sample(int bit_num, bit bit_val);
            coverpoint data_rdy  {
                bins full_cover[] = {[0:15]}; 
            }
            coverpoint bit_val {
                bins value[] = {0,1};
            }
            coverpoint bit_num {
                bins bit_number[] = {[0:3]};
            }
            cp_a_toggle : cross bit_num, bit_val, data_rdy ;
        endgroup

        function void cov_data_rdy_toggles(bit [3:0] value);
            for (int a=0; a < 4; a++) begin
                cg_data_rdy_toggle.sample(a, value[a]);
            end
        endfunction

        // Data_out Coverage
        covergroup cg_data_out;
            cp_data_out_1: coverpoint data_out[15:0] {
                bins data_out_max_1 = {16'hFFFF};
                bins data_out_range_1[8] = {[0:$]};
                bins data_out_min_1 = {16'h0};
            }
            cp_data_out_2: coverpoint data_out[31:16] {
                bins data_out_max_2 = {16'hFFFF};
                bins data_out_range_2[8] = {[0:$]};
                bins data_out_min_2 = {16'h0};
            }
            cp_data_out_3: coverpoint data_out[47:32] {
                bins data_out_max_3 = {16'hFFFF};
                bins data_out_range_3[8] = {[0:$]};
                bins data_out_min_3 = {16'h0};
            }
            cp_data_out_4: coverpoint data_out[63:48] {
                bins data_out_max_4 = {16'hFFFF};
                bins data_out_range_4[8] = {[0:$]};
                bins data_out_min_4 = {16'h0};
            }
        endgroup

        // Addr_out Coverage
        covergroup cg_addr_out;
            cp_addr_out_1: coverpoint addr_out[15:0] {
                bins addr_out_max_1 = {16'hFFFF};
                bins addr_out_range_1[8] = {[0:$]};
                bins addr_out_min_1 = {16'h0};
            }
            cp_addr_out_2: coverpoint addr_out[31:16] {
                bins addr_out_max_2 = {16'hFFFF};
                bins addr_out_range_2[8] = {[0:$]};
                bins addr_out_min_2 = {16'h0};
            }
            cp_addr_out_3: coverpoint addr_out[47:32] {
                bins addr_out_max_3 = {16'hFFFF};
                bins addr_out_range_3[8] = {[0:$]};
                bins addr_out_min_3 = {16'h0};
            }
            cp_addr_out_4: coverpoint addr_out[63:48] {
                bins addr_out_max_4 = {16'hFFFF};
                bins addr_out_range_4[8] = {[0:$]};
                bins addr_out_min_4 = {16'h0};
            }
        endgroup

        // Constructor
        function new(string name, uvm_component parent);
            super.new(name, parent);

            this.data_rcv = 0;
            this.addr_out = 0;
            this.data_out = 0;
            this.data_rdy = 0;
            this.fifo_empty = 255;
            this.fifo_full = 0;
            this.fifo_ae = 255;
            this.fifo_af = 0;

            // Coverage Initializations
            cg_addr_out = new();
            cg_data_output_indicators = new();
            cg_data_out = new();
            cg_data_rcv_toggle = new();
            cg_data_rdy_toggle =new();
            
            cg_fifo = new();
            cg_fifo_almost_empty_toggle = new();
            cg_fifo_almost_full_toggle =new();
            cg_fifo_empty_toggle = new();
            cg_fifo_full_toggle = new();
        endfunction
        
        // Write Function from the downstream
        function void write(transaction t);
            this.data_rcv = t.data_rcv;
            this.addr_out = t.addr_out;
            this.data_out = t.data_out;
            this.data_rdy = t.data_rdy;
            this.fifo_empty = t.fifo_empty;
            this.fifo_full = t.fifo_full;
            this.fifo_ae = t.fifo_ae;
            this.fifo_af = t.fifo_af;
            sample();
        endfunction

        // Function used to sample all covergroups in the Coverage
        function void sample();
            // Covergroup samples
            cg_data_output_indicators.sample();
            cg_fifo.sample();
            cg_data_out.sample();
            cg_addr_out.sample();

            // Toggle samples
            cov_fifo_empty_toggles(fifo_empty);
            cov_fifo_almost_empty_toggles(fifo_ae);
            cov_fifo_almost_full_toggles(fifo_af);
            cov_fifo_full_toggles(fifo_full);
            cov_data_rcv_toggles(data_rcv);
            cov_data_rdy_toggles(data_rdy);
        endfunction


    endclass
endpackage
