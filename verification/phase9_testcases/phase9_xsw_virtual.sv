`include "phase9_xsw_queue.sv"

class xsw_virtual;

    // async inputs
    logic reset;
    logic [3:0] full_flag;
  

    // xswitch internal memory 
    xsw_queue port_0;
    xsw_queue port_1;
    xsw_queue port_2;
    xsw_queue port_3;

    xsw_queue port_0_addr;
    xsw_queue port_1_addr;
    xsw_queue port_2_addr;
    xsw_queue port_3_addr;

    int port_active;
    int init_flag;
    logic [15:0] config_address_0;
    logic [15:0] config_address_1;
    logic [15:0] config_address_2;
    logic [15:0] config_address_3;

    // expected outputs
    logic [7:0] data_rcv;
    logic [7:0] data_rdy;
    logic [63:0] addr_out;
    logic [63:0] data_out;

    logic [7:0] fifo_ae;
    logic [7:0] fifo_empty;
    logic [7:0] fifo_full;
    logic [7:0] fifo_af;

    // Write Success Flags
    logic write_success_0;
    logic write_success_1;
    logic write_success_2;
    logic write_success_3;

    logic config_success_0;
    logic config_success_1;
    logic config_success_2;
    logic config_success_3;
    logic config_zero_flag;

    // Constructor
    function new();
        // Initialize Queue Classes
        this.port_0 = new();
        this.port_1 = new();
        this.port_2 = new();
        this.port_3 = new();

        this.port_0_addr = new();
        this.port_1_addr = new();
        this.port_2_addr = new();
        this.port_3_addr = new();

        // Initialize Internal Values
        this.reset = 0;
        this.full_flag = 0;

        this.port_active = 0;
        this.init_flag = 1;
        this.config_address_0 = 0;
        this.config_address_1 = 0;
        this.config_address_2 = 0;
        this.config_address_3 = 0;

        this.data_rcv = 8'b00000000;
        this.data_rdy = 8'b00000000;
        this.addr_out = 64'h0000000000000000;
        this.data_out = 64'h0000000000000000;
        this.fifo_empty = 8'b11111111;
        this.fifo_ae = 8'b11111111;
        this.fifo_full = 8'b00000000;
        this.fifo_af = 8'b00000000;

        this.write_success_0 = 0;
        this.write_success_1 = 0;
        this.write_success_2 = 0;
        this.write_success_3 = 0;
        this.config_success_0 = 0;
        this.config_success_1 = 0;
        this.config_success_2 = 0;
        this.config_success_3 = 0;
        this.config_zero_flag = 1;
    endfunction

    function void update(logic [63:0] addr_in, logic [63:0] data_in, logic [7:0] wr_en, logic [7:0] rd_en, logic port_en, logic port_wr, logic [7:0] port_sel, logic [15:0] port_addr, logic rst);
        this.reset = rst;
        config_addr_control(port_en, port_wr, port_sel, port_addr);
        read_control(rd_en);
        write_control(addr_in, data_in, wr_en);
        data_rdy_control();
        data_rcv_control(wr_en, addr_in);
        fifo_ae_control();
        fifo_empty_control();
        fifo_full_control();
        fifo_af_control();
	//$display("%0d %0d %0d %0d", config_address_0, config_address_1, config_address_2, config_address_3);
    endfunction

    // update fifo_empty
    function void fifo_empty_control();
        if (this.reset == 1) begin
            this.fifo_empty = 8'b11111111;
        end
        else begin
            this.fifo_empty[0] = this.port_0.is_empty;
            this.fifo_empty[1] = this.port_1.is_empty;
            this.fifo_empty[2] = this.port_2.is_empty;
            this.fifo_empty[3] = this.port_3.is_empty;
            this.fifo_empty[4] = this.port_0_addr.is_empty;
            this.fifo_empty[5] = this.port_1_addr.is_empty;
            this.fifo_empty[6] = this.port_2_addr.is_empty;
            this.fifo_empty[7] = this.port_3_addr.is_empty;
        end
    endfunction

    // update fifo_ae
    function void fifo_ae_control();
        if (this.reset == 1) begin
            this.fifo_ae = 8'b11111111;
        end
        else begin
            this.fifo_ae[0] = this.port_0.is_almost_empty;
            this.fifo_ae[1] = this.port_1.is_almost_empty;
            this.fifo_ae[2] = this.port_2.is_almost_empty;
            this.fifo_ae[3] = this.port_3.is_almost_empty;
            this.fifo_ae[4] = this.port_0_addr.is_almost_empty;
            this.fifo_ae[5] = this.port_1_addr.is_almost_empty;
            this.fifo_ae[6] = this.port_2_addr.is_almost_empty;
            this.fifo_ae[7] = this.port_3_addr.is_almost_empty;
        end
    endfunction

    // update fifo_full
    function void fifo_full_control();
        if (this.reset == 1) begin
            this.fifo_full = 8'b00000000;
        end
        else begin
            this.fifo_full[0] = this.port_0.is_full;
            this.fifo_full[1] = this.port_1.is_full;
            this.fifo_full[2] = this.port_2.is_full;
            this.fifo_full[3] = this.port_3.is_full;
            this.fifo_full[4] = this.port_0_addr.is_full;
            this.fifo_full[5] = this.port_1_addr.is_full;
            this.fifo_full[6] = this.port_2_addr.is_full;
            this.fifo_full[7] = this.port_3_addr.is_full;
        end
    endfunction

    // update fifo_ae
    function void fifo_af_control();
        if (this.reset == 1) begin
            this.fifo_af = 8'b00000000;
        end
        else begin
            this.fifo_af[0] = this.port_0.is_almost_full;
            this.fifo_af[1] = this.port_1.is_almost_full;
            this.fifo_af[2] = this.port_2.is_almost_full;
            this.fifo_af[3] = this.port_3.is_almost_full;
            this.fifo_af[4] = this.port_0_addr.is_almost_full;
            this.fifo_af[5] = this.port_1_addr.is_almost_full;
            this.fifo_af[6] = this.port_2_addr.is_almost_full;
            this.fifo_af[7] = this.port_3_addr.is_almost_full;
        end
    endfunction

    // set the address configurations for the output ports
    function void config_addr_control(logic port_en, logic port_wr, logic [7:0] port_sel, logic [15:0] port_addr);
        if (reset == 1) begin
            this.config_address_0 = 0;
            this.config_address_1 = 0; 
            this.config_address_2 = 0; 
            this.config_address_3 = 0;  
            this.config_success_0 = 0;
            this.config_success_1 = 0;
            this.config_success_2 = 0;
            this.config_success_3 = 0;
            this.config_zero_flag = 1;
            this.port_active = this.config_success_0 + this.config_success_1 + this.config_success_2 + this.config_success_3;
        end else if (port_en & port_wr) begin
            if (port_sel == 0) begin
                if ((port_addr == 0) && (this.config_zero_flag == 1)) begin
                    this.config_address_0 = port_addr;
                    this.config_success_0 = 1;
                    this.config_zero_flag = 0;
		end else if ((config_address_0 == 0) && (port_addr == 0)) begin
		    this.config_address_0 = port_addr;
		    this.config_success_0 = 1;
		    this.config_zero_flag =0;
                end else if ((port_addr == 0) && (this.config_zero_flag == 0)) begin
                    this.config_address_0 = 0;
                    this.config_address_1 = 0; 
                    this.config_address_2 = 0; 
                    this.config_address_3 = 0;  
                    this.config_success_0 = 0;
                    this.config_success_1 = 0;
                    this.config_success_2 = 0;
                    this.config_success_3 = 0;
                    this.config_zero_flag = 0;
                end else begin
                    if (port_addr != config_address_1) begin
                        if (port_addr != config_address_2) begin
                            if (port_addr != config_address_3) begin
                                this.config_address_0 = port_addr;
                                this.config_success_0 = 1;
                            end else begin
                                this.config_address_0 = 0;
                                this.config_address_1 = 0; 
                                this.config_address_2 = 0; 
                                this.config_address_3 = 0;  
                                this.config_success_0 = 0;
                                this.config_success_1 = 0;
                                this.config_success_2 = 0;
                                this.config_success_3 = 0;
                                this.config_zero_flag = 1;
                            end
                        end else begin
                            this.config_address_0 = 0;
                            this.config_address_1 = 0; 
                            this.config_address_2 = 0; 
                            this.config_address_3 = 0;  
                            this.config_success_0 = 0;
                            this.config_success_1 = 0;
                            this.config_success_2 = 0;
                            this.config_success_3 = 0;
                            this.config_zero_flag = 1;
                        end
                    end else begin
                        this.config_address_0 = 0;
                        this.config_address_1 = 0; 
                        this.config_address_2 = 0; 
                        this.config_address_3 = 0;  
                        this.config_success_0 = 0;
                        this.config_success_1 = 0;
                        this.config_success_2 = 0;
                        this.config_success_3 = 0;
                        this.config_zero_flag = 1;
                    end
                end
            end
            else if (port_sel == 1) begin
                if ((port_addr == 0) && (this.config_zero_flag == 1)) begin
                    this.config_address_1 = port_addr;
                    this.config_success_1 = 1;
                    this.config_zero_flag = 0;
		end else if ((config_address_1 == 0) && (port_addr == 0)) begin
                    this.config_address_1 = port_addr;
                    this.config_success_1 = 1;
                    this.config_zero_flag =0;
                end else if ((port_addr == 0) && (this.config_zero_flag == 0)) begin
                    this.config_address_0 = 0;
                    this.config_address_1 = 0; 
                    this.config_address_2 = 0; 
                    this.config_address_3 = 0;  
                    this.config_success_0 = 0;
                    this.config_success_1 = 0;
                    this.config_success_2 = 0;
                    this.config_success_3 = 0;
                    this.config_zero_flag = 0;
                end else begin
                    if (port_addr != config_address_0) begin
                        if (port_addr != config_address_2) begin
                            if (port_addr != config_address_3) begin
                                this.config_address_1 = port_addr;
                                this.config_success_1 = 1;
                            end else begin
                                this.config_address_0 = 0;
                                this.config_address_1 = 0; 
                                this.config_address_2 = 0; 
                                this.config_address_3 = 0;  
                                this.config_success_0 = 0;
                                this.config_success_1 = 0;
                                this.config_success_2 = 0;
                                this.config_success_3 = 0;
                                this.config_zero_flag = 1;
                            end
                        end else begin
                            this.config_address_0 = 0;
                            this.config_address_1 = 0; 
                            this.config_address_2 = 0; 
                            this.config_address_3 = 0;  
                            this.config_success_0 = 0;
                            this.config_success_1 = 0;
                            this.config_success_2 = 0;
                            this.config_success_3 = 0;
                            this.config_zero_flag = 1;
                        end
                    end else begin
                        this.config_address_0 = 0;
                        this.config_address_1 = 0; 
                        this.config_address_2 = 0; 
                        this.config_address_3 = 0;  
                        this.config_success_0 = 0;
                        this.config_success_1 = 0;
                        this.config_success_2 = 0;
                        this.config_success_3 = 0;
                        this.config_zero_flag = 1;
                    end
                end
            end
            else if (port_sel == 2) begin
                if ((port_addr == 0) && (this.config_zero_flag == 1)) begin
                    this.config_address_2 = port_addr;
                    this.config_success_2 = 1;
                    this.config_zero_flag = 0;
		end else if ((config_address_2 == 0) && (port_addr == 0)) begin
                    this.config_address_2 = port_addr;
                    this.config_success_2 = 1;
                    this.config_zero_flag =0;
                end else if ((port_addr == 0) && (this.config_zero_flag == 0)) begin
                    this.config_address_0 = 0;
                    this.config_address_1 = 0; 
                    this.config_address_3 = 0;  
                    this.config_success_0 = 0;
                    this.config_success_1 = 0;
                    this.config_success_3 = 0;
                    this.config_zero_flag = 0;
                end else begin
                    if (port_addr != config_address_0) begin
                        if (port_addr != config_address_1) begin
                            if (port_addr != config_address_3) begin
                                this.config_address_2 = port_addr;
                                this.config_success_2 = 1;
                            end else begin
                                this.config_address_0 = 0;
                                this.config_address_1 = 0; 
                                this.config_address_2 = 0; 
                                this.config_address_3 = 0;  
                                this.config_success_0 = 0;
                                this.config_success_1 = 0;
                                this.config_success_2 = 0;
                                this.config_success_3 = 0;
                                this.config_zero_flag = 1;
                            end
                        end else begin
                            this.config_address_0 = 0;
                            this.config_address_1 = 0; 
                            this.config_address_2 = 0; 
                            this.config_address_3 = 0;  
                            this.config_success_0 = 0;
                            this.config_success_1 = 0;
                            this.config_success_2 = 0;
                            this.config_success_3 = 0;
                            this.config_zero_flag = 1;
                        end
                    end else begin
                        this.config_address_0 = 0;
                        this.config_address_1 = 0; 
                        this.config_address_2 = 0; 
                        this.config_address_3 = 0;  
                        this.config_success_0 = 0;
                        this.config_success_1 = 0;
                        this.config_success_2 = 0;
                        this.config_success_3 = 0;
                        this.config_zero_flag = 1;
                    end
                end
            end
            else if (port_sel == 3) begin
                if ((port_addr == 0) && (this.config_zero_flag == 1)) begin
                    this.config_address_3 = port_addr;
                    this.config_success_3 = 1;
                    this.config_zero_flag = 0;
		end else if ((config_address_3 == 0) && (port_addr == 0)) begin
                    this.config_address_3 = port_addr;
                    this.config_success_3 = 1;
                    this.config_zero_flag =0;
                end else if ((port_addr == 0) && (this.config_zero_flag == 0)) begin
                    this.config_address_0 = 0;
                    this.config_address_1 = 0; 
                    this.config_address_2 = 0; 
                    this.config_address_3 = 0;  
                    this.config_success_0 = 0;
                    this.config_success_1 = 0;
                    this.config_success_2 = 0;
                    this.config_success_3 = 0;
                    this.config_zero_flag = 0;
                end else begin
                    if (port_addr != config_address_0) begin
                        if (port_addr != config_address_1) begin
                            if (port_addr != config_address_2) begin
                                this.config_address_3 = port_addr;
                                this.config_success_3 = 1;
                            end else begin
                                this.config_address_0 = 0;
                                this.config_address_1 = 0; 
                                this.config_address_2 = 0; 
                                this.config_address_3 = 0;  
                                this.config_success_0 = 0;
                                this.config_success_1 = 0;
                                this.config_success_2 = 0;
                                this.config_success_3 = 0;
                                this.config_zero_flag = 1;
                            end
                        end else begin
                            this.config_address_0 = 0;
                            this.config_address_1 = 0; 
                            this.config_address_2 = 0; 
                            this.config_address_3 = 0;  
                            this.config_success_0 = 0;
                            this.config_success_1 = 0;
                            this.config_success_2 = 0;
                            this.config_success_3 = 0;
                            this.config_zero_flag = 1;
                        end
                    end else begin
                        this.config_address_0 = 0;
                        this.config_address_1 = 0; 
                        this.config_address_2 = 0; 
                        this.config_address_3 = 0;  
                        this.config_success_0 = 0;
                        this.config_success_1 = 0;
                        this.config_success_2 = 0;
                        this.config_success_3 = 0;
                        this.config_zero_flag = 1;
                    end
                end
            end
            this.port_active = this.config_success_0 + this.config_success_1 + this.config_success_2 + this.config_success_3;
        end
    endfunction

    // controls the data_rcv value based on the number of configurations set
    function void data_rcv_control(logic [7:0] wr_en, logic [63:0] addr_in);
        if (this.reset) begin
            this.data_rcv = 0;
	    this.init_flag = 1;
        end else if (this.port_active >= 3) begin
            if (init_flag == 1) begin
                this.data_rcv = 15;
                this.write_success_0 = 1;
                this.write_success_1 = 1;
                this.write_success_2 = 1;
                this.write_success_3 = 1;
                this.init_flag = 0;
            end else if (wr_en != 0) begin
                this.data_rcv[0] = this.write_success_0;
                this.data_rcv[1] = this.write_success_1;
                this.data_rcv[2] = this.write_success_2;
                this.data_rcv[3] = this.write_success_3;
            end
        end else if (this.port_active < 3) begin
            this.data_rcv = 0;
	    this.init_flag = 1;;
    end
    endfunction

    // controls the data_rdy value based on the number of configurations set
    function void data_rdy_control();
        if (this.reset == 1) begin
            this.data_rdy = 0;
        end else if (this.port_active >= 3) begin
            if (this.port_0.is_empty == 0) begin 
                this.data_rdy[0] = 1;
            end else begin
                this.data_rdy[0] = 0;
            end  
            if (this.port_1.is_empty == 0) begin 
                this.data_rdy[1] = 1;
            end else begin
                this.data_rdy[1] = 0;
            end 
            if (this.port_2.is_empty == 0) begin 
                this.data_rdy[2] = 1;
            end else begin
                this.data_rdy[2] = 0;
            end 
            if (this.port_3.is_empty == 0) begin 
                this.data_rdy[3] = 1;
            end else begin
                this.data_rdy[3] = 0;
            end

            // if (rd_en[0])begin 
            //     if (this.port_0.is_empty == 0) begin 
            //         this.data_rdy[0] = 1;
            //     end else begin
            //         this.data_rdy[0] = 0;
            //     end  
            // end
            // if (rd_en[1])begin 
            //     if (this.port_1.is_empty == 0) begin 
            //         this.data_rdy[1] = 1;
            //     end else begin
            //         this.data_rdy[1] = 0;
            //     end  
            // end
            // if (rd_en[2])begin 
            //     if (this.port_2.is_empty == 0) begin 
            //         this.data_rdy[2] = 1;
            //     end else begin
            //         this.data_rdy[2] = 0;
            //     end  
            // end
            // if (rd_en[3])begin 
            //     if (this.port_3.is_empty == 0) begin 
            //         this.data_rdy[3] = 1;
            //     end else begin
            //         this.data_rdy[3] = 0;
            //     end  
            // end

            // if (wr_en[0])begin 
            //     if (this.port_0.is_full == 0) begin 
            //         this.data_rdy[0] = write_success_0;
            //     end 
            // end

            // if (wr_en[1])begin 
            //     if (this.port_1.is_full == 0) begin 
            //         this.data_rdy[1] = write_success_1;
            //     end 
            // end

            // if (wr_en[2])begin 
            //     if (this.port_2.is_empty == 0) begin 
            //         this.data_rdy[2] = write_success_2;
            //     end 
            // end

            // if (wr_en[3])begin 
            //     if (this.port_3.is_empty == 0) begin 
            //         this.data_rdy[3] = write_success_3;
            //     end 
            // end
            
        end 
    endfunction

    // Writes into the queue
    function void write_control(logic [63:0] addr_in, logic [63:0] data_in, logic [7:0] wr_en);
        if(this.reset == 1) begin
            this.port_0.clear();
            this.port_1.clear();
            this.port_2.clear();
            this.port_3.clear();
            this.port_0_addr.clear();
            this.port_1_addr.clear();
            this.port_2_addr.clear();
            this.port_3_addr.clear();
        end else if (this.port_active >= 3)begin
            // Process the first 16-bit of data_in and addr_in
            if (addr_in[15:0] == config_address_0) begin
                if (wr_en[0] == 1) begin
                    if (port_0.is_full()) begin
                        this.write_success_0 = 0;
                    end else begin
                        this.write_success_0 = 1;
                        port_0.enqueue(wr_en[0], data_in[15:0]);
                        port_0_addr.enqueue(wr_en[0], 16'h0000);
                    end
                end
            end
            else if (addr_in[15:0] == config_address_1) begin
                if (wr_en[0] == 1) begin
                    if (port_1.is_full()) begin
                        this.write_success_0 = 0;
                    end else begin
                        this.write_success_0 = 1;
                        port_1.enqueue(wr_en[0], data_in[15:0]);
                        port_1_addr.enqueue(wr_en[0], 16'h0000);
                    end
                end
            end
            else if (addr_in[15:0] == config_address_2) begin
                if (wr_en[0] == 1) begin
                    if (port_2.is_full()) begin
                        this.write_success_0 = 0;
                    end else begin
                        this.write_success_0 = 1;
                        port_2.enqueue(wr_en[0], data_in[15:0]);
                        port_2_addr.enqueue(wr_en[0], 16'h0000);
                    end
                end
            end
            else if (addr_in[15:0] == config_address_3) begin
                if (wr_en[0] == 1) begin
                    if (port_3.is_full()) begin
                        this.write_success_0 = 0;
                    end else begin
                        this.write_success_0 = 1;
                        port_3.enqueue(wr_en[0], data_in[15:0]);
                        port_3_addr.enqueue(wr_en[0], 16'h0000);
                    end
                end
            end
            
            // Process the second 16-bit of data_in and addr_in
            if (addr_in[31:16] == config_address_0) begin
                if (wr_en[1] == 1) begin
                    if (port_0.is_full()) begin
                        this.write_success_1 = 0;
                    end else begin
                        this.write_success_1 = 1;
                        port_0.enqueue(wr_en[1], data_in[31:16]);
                        port_0_addr.enqueue(wr_en[1], 16'h0001);
                    end
                end
            end
            else if (addr_in[31:16] == config_address_1) begin
                if (wr_en[1] == 1) begin
                    if (port_1.is_full()) begin
                        this.write_success_1 = 0;
                    end else begin
                        this.write_success_1 = 1;
                        port_1.enqueue(wr_en[1], data_in[31:16]);
                        port_1_addr.enqueue(wr_en[1], 16'h0001);
                    end
                end
            end
            else if (addr_in[31:16] == config_address_2) begin
                if (wr_en[1] == 1) begin
                    if (port_2.is_full()) begin
                        this.write_success_1 = 0;
                    end else begin
                        this.write_success_1 = 1;
                        port_2.enqueue(wr_en[1], data_in[31:16]);
                        port_2_addr.enqueue(wr_en[1], 16'h0001);
                    end
                end
            end
            else if (addr_in[31:16] == config_address_3) begin
                if (wr_en[1] == 1) begin
                    if (port_3.is_full()) begin
                        this.write_success_1 = 0;
                    end else begin
                        this.write_success_1 = 1;
                        port_3.enqueue(wr_en[1], data_in[31:16]);
                        port_3_addr.enqueue(wr_en[1], 16'h0001);
                    end
                end
            end

            // Process the third 16-bit of data_in and addr_in
            if (addr_in[47:32] == config_address_0) begin
                if (wr_en[2] == 1) begin
                    if (port_0.is_full()) begin
                        this.write_success_2 = 0;
                    end else begin
                        this.write_success_2 = 1;
                        port_0.enqueue(wr_en[2], data_in[47:32]);
                        port_0_addr.enqueue(wr_en[2], 16'h0002);
                    end
                end
            end
            else if (addr_in[47:32] == config_address_1) begin
                if (wr_en[2] == 1) begin
                    if (port_1.is_full()) begin
                        this.write_success_2 = 0;
                    end else begin
                        this.write_success_2 = 1;
                        port_1.enqueue(wr_en[2], data_in[47:32]);
                        port_1_addr.enqueue(wr_en[2], 16'h0002);
                    end
                end
            end
            else if (addr_in[47:32] == config_address_2) begin
                if (wr_en[2] == 1) begin
                    if (port_2.is_full()) begin
                        this.write_success_2 = 0;
                    end else begin
                        this.write_success_2 = 1;
                        port_2.enqueue(wr_en[2], data_in[47:32]);
                        port_2_addr.enqueue(wr_en[2], 16'h0002);
                    end
                end
            end
            else if (addr_in[47:32] == config_address_3) begin
                if (wr_en[2] == 1) begin
                    if (port_3.is_full()) begin
                        this.write_success_2 = 0;
                    end else begin
                        this.write_success_2 = 1;
                        port_3.enqueue(wr_en[2], data_in[47:32]);
                        port_3_addr.enqueue(wr_en[2], 16'h0002);
                    end
                end
            end

            // Process the fourth 16-bit of data_in and addr_in
            if (addr_in[63:48] == config_address_0) begin
                if (wr_en[3] == 1) begin
                    if (port_0.is_full()) begin
                        this.write_success_3 = 0;
                    end else begin
                        this.write_success_3 = 1;
                        port_0.enqueue(wr_en[3], data_in[63:48]);
                        port_0_addr.enqueue(wr_en[3], 16'h0003);
                    end
                end
            end
            else if (addr_in[63:48] == config_address_1) begin
                if (wr_en[3] == 1) begin
                    if (port_1.is_full()) begin
                        this.write_success_3 = 0;
                    end else begin
                        this.write_success_3 = 1;
                        port_1.enqueue(wr_en[3], data_in[63:48]);
                        port_1_addr.enqueue(wr_en[3], 16'h0003);
                    end
                end
            end
            else if (addr_in[63:48] == config_address_2) begin
                if (wr_en[3] == 1) begin
                    if (port_2.is_full()) begin
                        this.write_success_3 = 0;
                    end else begin
                        this.write_success_3 = 1;
                        port_2.enqueue(wr_en[3], data_in[63:48]);
                        port_2_addr.enqueue(wr_en[3], 16'h0003);
                    end
                end
            end
            else if (addr_in[63:48] == config_address_3) begin
                if (wr_en[3] == 1) begin
                    if (port_3.is_full()) begin
                        this.write_success_3 = 0;
                    end else begin
                        this.write_success_3 = 1;
                        port_3.enqueue(wr_en[3], data_in[63:48]);
                        port_3_addr.enqueue(wr_en[3], 16'h0003);
                    end
                end
            end
        end
    endfunction

    function void read_control(logic [7:0] rd_en);
        if(this.reset == 1) begin
            this.addr_out = 64'h0000000000000000;
            this.data_out = 64'h0000000000000000;
        end else if (this.port_active >= 3)begin
            if (this.port_0.is_empty() == 0 && rd_en[0] == 1) begin 
                this.data_out[15:0] = this.port_0.dequeue(rd_en[0]);
                this.addr_out[15:0] = this.port_0_addr.dequeue(rd_en[0]);
            end
            if (this.port_1.is_empty() == 0 && rd_en[1] == 1) begin 
                this.data_out[31:16] = this.port_1.dequeue(rd_en[1]);
                this.addr_out[31:16] = this.port_1_addr.dequeue(rd_en[1]);
            end
            if (this.port_2.is_empty() == 0 && rd_en[2] == 1) begin 
                this.data_out[47:32] = this.port_2.dequeue(rd_en[2]);
                this.addr_out[47:32] = this.port_2_addr.dequeue(rd_en[2]);
            end
            if (this.port_3.is_empty() == 0 && rd_en[3] == 1) begin 
                this.data_out[63:48] = this.port_3.dequeue(rd_en[3]);
                this.addr_out[63:48] = this.port_3_addr.dequeue(rd_en[3]);
            end
        end 
    endfunction

endclass
