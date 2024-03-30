`include "uvm_macros.svh"
`include "phase7_xsw_virtual.sv"
import uvm_pkg::*;
`uvm_analysis_imp_decl(_upstream)
`uvm_analysis_imp_decl(_downstream)

class xsw_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(xsw_scoreboard)
    
    uvm_analysis_imp_upstream #(transaction, xsw_scoreboard) port_up;
    uvm_analysis_imp_downstream #(transaction, xsw_scoreboard) port_down;

    int up_ind; 
    int down_ind;

    transaction t_up;
    transaction t_down;
    string name;
    int error_counter;

    // Instance of Virtual Xswitch
    xsw_virtual xswitch;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      port_up = new("port_up", this);
      port_down = new("port_down", this);
      xswitch = new();
      name = "transaction";
    endfunction

    function void write_downstream(transaction tx);
      //`uvm_info("SAMPLE", $psprintf("THESE ARE THE DOWNSTREAM OUTPUTS\n%s", tx.toString()), UVM_NONE);
      t_down = tx;
      up_ind = 1;
      compare();
    endfunction

    function void write_upstream(transaction tx);
      //`uvm_info("SAMPLE", $psprintf("THESE ARE THE UPSTREAM OUTPUTS\n%s", tx.toString()), UVM_NONE);
      t_up = tx;
      down_ind = 1;
      compare();
    endfunction

    function void compare();
      if(up_ind & down_ind) begin
        up_ind = 0;
        down_ind = 0;
        xswitch.update(t_up.addr_in, t_up.data_in, t_up.wr_en, t_up.rd_en, t_up.port_en, t_up.port_wr, t_up.port_sel, t_up.port_addr, t_up.reset);
  
        // addr_out check
        if(t_down.addr_out[63:48] != xswitch.addr_out[63:48]) begin
          error_counter = error_counter + 1;
          $display("Error in addr_out[63:38]");
        end
        if(t_down.addr_out[47:32] != xswitch.addr_out[47:32]) begin
          error_counter = error_counter + 1;
          $display("Error in addr_out[47:32]");
        end
        if(t_down.addr_out[31:16] != xswitch.addr_out[31:16]) begin
          $display("Error in addr_out[31:16]");
          error_counter = error_counter + 1;
        end
        if(t_down.addr_out[15:0] != xswitch.addr_out[15:0]) begin
          $display("Error in addr_out[15:0]");
          error_counter = error_counter + 1;
        end
        
        // data_out check
        if (t_down.data_out[63:48] != xswitch.data_out[63:48]) begin
          error_counter = error_counter + 1;
          $display("Error in data_out[63:38]");
        end 
        if (t_down.data_out[47:32] != xswitch.data_out[47:32]) begin
          error_counter = error_counter + 1;
          $display("Error in data_out[47:32]");
        end
        if (t_down.data_out[31:16] != xswitch.data_out[31:16]) begin
          error_counter = error_counter + 1;
          $display("Error in data_out[31:16]");
        end
        if (t_down.data_out[15:0] != xswitch.data_out[15:0]) begin
          error_counter = error_counter + 1;
          $display("Error in data_out[15:0]");
        end

        // data_rcv and data_rdy check
        if(t_down.data_rcv != xswitch.data_rcv) begin
          error_counter = error_counter + 1;
          $display("Error in data_rcv");
        end
        if(t_down.data_rdy != xswitch.data_rdy) begin
          error_counter = error_counter + 1;
          $display("Error in data_rdy");
        end
        
        // fifo checks (empty, full, almost empty, and almost full)
        if(t_down.fifo_empty != xswitch.fifo_empty) begin
          error_counter = error_counter + 1;
          $display("Error in fifo_empty");
        end
        if(t_down.fifo_full != xswitch.fifo_full) begin
          error_counter = error_counter + 1;
          $display("Error in fifo_full");
        end
        if(t_down.fifo_ae != xswitch.fifo_ae) begin
          error_counter = error_counter + 1;
          $display("Error in fifo_ae");
        end
        if(t_down.fifo_af != xswitch.fifo_af) begin
          error_counter = error_counter + 1;
          $display("Error in fifo_af");
        end

        if (error_counter == 0) begin
          `uvm_info("PASS", $psprintf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"), UVM_NONE);
        end else begin
          $display("%0d %0d %0d %0d %0d", xswitch.port_active, xswitch.config_success_0, xswitch.config_success_1, xswitch.config_success_2, xswitch.config_success_3 );
          `uvm_info("FAIL", $psprintf("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"), UVM_NONE);
          $display("#################### INPUTS #######################");
          $display();
          $display("%s: Reset = %0b", name, t_up.reset);
          $display();
          $display("%s: addr_in =     0X%4h_%4h_%4h_%4h", name, t_up.addr_in[63:48], t_up.addr_in[47:32], t_up.addr_in[31:16], t_up.addr_in[15:0]);
          $display("%s: data_in =     0X%4h_%4h_%4h_%4h", name, t_up.data_in[63:48], t_up.data_in[47:32], t_up.data_in[31:16], t_up.data_in[15:0]);
          $display();
          $display("%s: wr_en =       0B%8b   rd_en =       0B%8b", name, t_up.wr_en, t_up.rd_en);
          $display();
          $display("%s: port_en =     0B%1b   port_wr =     0B%1b", name, t_up.port_en, t_up.port_wr);
          $display("%s: port_sel =    0B%8b   port_addr =   0X%4h", name, t_up.port_sel, t_up.port_addr);
          $display();
          $display("#################### OUTPUTS #######################");
          $display();
          $display("%s: addr_out =   0X%4h_%4h_%4h_%4h", name, t_down.addr_out[63:48], t_down.addr_out[47:32], t_down.addr_out[31:16], t_down.addr_out[15:0]);
          $display("%s: data_out =   0X%4h_%4h_%4h_%4h", name, t_down.data_out[63:48], t_down.data_out[47:32], t_down.data_out[31:16], t_down.data_out[15:0]);
          $display();
          $display("%s: data_rcv =    0B%8b   data_rdy =    0B%8b", name, t_down.data_rcv, t_down.data_rdy);
          $display();
          $display("%s: fifo_empty =  0B%8b   fifo_full =   0B%8b", name, t_down.fifo_empty, t_down.fifo_full);
          $display("%s: fifo_ae =     0B%8b   fifo_af =     0B%8b", name, t_down.fifo_ae, t_down.fifo_af);
          $display();
          $display("#################### EXPECTED ######################");
          $display();
          $display("%s: addr_out =   0X%4h_%4h_%4h_%4h", name, xswitch.addr_out[63:48], xswitch.addr_out[47:32], xswitch.addr_out[31:16], xswitch.addr_out[15:0]);
          $display("%s: data_out =   0X%4h_%4h_%4h_%4h", name, xswitch.data_out[63:48], xswitch.data_out[47:32], xswitch.data_out[31:16], xswitch.data_out[15:0]);
          $display();
          $display("%s: data_rcv =    0B%8b   data_rdy =    0B%8b", name, xswitch.data_rcv, xswitch.data_rdy);
          $display();
          $display("%s: fifo_empty =  0B%8b   fifo_full =   0B%8b", name, xswitch.fifo_empty, xswitch.fifo_full);
          $display("%s: fifo_ae =     0B%8b   fifo_af =     0B%8b", name, xswitch.fifo_ae, xswitch.fifo_af);
          $display();
          $display("####################################################");
        end
        error_counter = 0;
      end
          
    endfunction
endclass
