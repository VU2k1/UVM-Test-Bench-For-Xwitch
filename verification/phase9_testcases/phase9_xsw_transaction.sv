package xsw_transaction;
    `include "uvm_macros.svh"
    import uvm_pkg::*;

    class transaction extends uvm_sequence_item;
        `uvm_object_utils(transaction)

        rand bit reset;
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

    class transaction_sanity extends transaction;
        `uvm_object_utils(transaction_sanity)
        
        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}

        constraint addr_in_0_control { addr_in[15:0] inside {[1:4]};}
        constraint addr_in_1_control { addr_in[31:16] inside {[1:4]};}
        constraint addr_in_2_control { addr_in[47:32] inside {[1:4]};}
        constraint addr_in_3_control { addr_in[63:48] inside {[1:4]};}

        constraint write_enable { wr_en inside {[0:15]};}
        constraint read_enable { rd_en inside {[0:15]};}

        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint port_sel_control { port_sel == 0;}
        constraint port_addr_control { port_addr == 0;}
    endclass

    class transaction_reset extends transaction;
        `uvm_object_utils(transaction_reset)
        
        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset dist {0 := 1, 1 := 3};}
	constraint port_en_control { port_en == 0;}
	constraint port_wr_control { port_wr == 0;}
    endclass

    class transaction_config_repeat extends transaction;
        `uvm_object_utils(transaction_config_repeat)
        
        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint port_en_control { port_en == 1;}
        constraint port_wr_control { port_wr == 1;}
        constraint port_sel_control { 
            port_sel inside {[0:3]};
            port_sel dist {0 := 1, 1 := 1, 2 := 90, 3 := 1};
        }
    endclass

    class transaction_config_non_unique extends transaction;
        `uvm_object_utils(transaction_config_non_unique)
        
        function new(string name = "");
            super.new(name);
        endfunction
        
        constraint reset_control { reset == 0;}
        constraint port_en_control { port_en == 1;}
        constraint port_wr_control { port_wr == 1;}
        constraint port_sel_control {
            port_sel inside {[0:3]};
        }
        constraint port_addr_control {
            port_addr inside{[0:3]};
            port_addr dist {0 := 1, 1 := 1, 2 := 30, 3 := 1};
        }
       
    endclass

    class transaction_random_config extends transaction;
        `uvm_object_utils(transaction_random_config)
        
        function new(string name = "");
            super.new(name);
        endfunction
        
        constraint reset_control { reset == 0;}
        constraint port_en_control { port_en == 1;}
        constraint port_wr_control { port_wr == 1;}
        constraint port_sel_control {port_sel inside {[0:3]};}
        constraint port_addr_control {port_addr inside{[0:3]};}
       
    endclass

    class transaction_rcv_off extends transaction;
        `uvm_object_utils(transaction_rcv_off)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint wr_en_control {wr_en inside {[1:15]};}
            
    endclass

    class transaction_write_full extends transaction;
        `uvm_object_utils(transaction_write_full)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint wr_en_control { wr_en == 15;}
        constraint read_control { rd_en == 0; }
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint addr_in_0_control { addr_in[15:0] inside {[1:4]};}
        constraint addr_in_1_control { addr_in[31:16] inside {[1:4]};}
        constraint addr_in_2_control { addr_in[47:32] inside {[1:4]};}
        constraint addr_in_3_control { addr_in[63:48] inside {[1:4]};}

    endclass
    
    class transaction_write_random extends transaction;
        `uvm_object_utils(transaction_write_random)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint read_control { rd_en == 0; }
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint write_enable { wr_en inside {[0:15]};}
        constraint addr_in_0_control { addr_in[15:0] inside {[1:4]};}
        constraint addr_in_1_control { addr_in[31:16] inside {[1:4]};}
        constraint addr_in_2_control { addr_in[47:32] inside {[1:4]};}
        constraint addr_in_3_control { addr_in[63:48] inside {[1:4]};}

    endclass

    class transaction_addr_in extends transaction;
        `uvm_object_utils(transaction_addr_in)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint read_control { rd_en == 0; }
        constraint wr_en_control { wr_en == 15;}
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint addr_in_0_control { addr_in[15:0] dist {1 := 3000, 2 := 3000, 3 := 3000, 4 := 3000};}
        constraint addr_in_1_control { addr_in[31:16] dist {1 := 3000, 2 := 3000, 3 := 3000, 4 := 3000};}
        constraint addr_in_2_control { addr_in[47:32] dist {1 := 3000, 2 := 3000, 3 := 3000, 4 := 3000};}
        constraint addr_in_3_control { addr_in[63:48] dist {1 := 3000, 2 := 3000, 3 := 3000, 4 := 3000};}
    endclass

    class transaction_rdy_off extends transaction;
        `uvm_object_utils(transaction_rdy_off)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint read_control { rd_en == 15; }
        constraint wr_en_control { wr_en == 0;}
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
    endclass

    class transaction_read_random extends transaction;
        `uvm_object_utils(transaction_read_random)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint wr_en_control { wr_en == 0;}
        constraint read_enable { rd_en inside {[0:15]};}
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
    endclass

    class transaction_read_and_write extends transaction;
        `uvm_object_utils(transaction_read_and_write)

        function new(string name = "");
            super.new(name);
        endfunction

        constraint reset_control { reset == 0;}
        constraint port_en_control { port_en == 0;}
        constraint port_wr_control { port_wr == 0;}
        constraint addr_in_0_control { addr_in[15:0] inside {[1:4]};}
        constraint addr_in_1_control { addr_in[31:16] inside {[1:4]};}
        constraint addr_in_2_control { addr_in[47:32] inside {[1:4]};}
        constraint addr_in_3_control { addr_in[63:48] inside {[1:4]};}
    endclass


endpackage
