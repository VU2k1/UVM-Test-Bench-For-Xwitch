class xsw_queue;
    logic [15:0] data [$:255];
    logic [15:0] prev_data;
    // Constructor
    function new ();
        clear();
    endfunction

    // Enqueue a 16-bit item into the queue
    function void enqueue (logic wr_en, logic [15:0] data_in);
        if (wr_en) begin
            if (data.size() < 256) begin
                 // if fifo is not full
                data.push_back(data_in);
            end
        end
    endfunction

    // Dequeue a 16-bit item out of the queue
    function logic [15:0] dequeue(logic rd_en);
        if (rd_en) begin
            if (data.size() > 0) begin
                prev_data = data.pop_front();
            end
            return prev_data;
        end
        else begin
            return prev_data;
        end
    endfunction

    // Check if the Queue is Empty (1 if true, 0 if false)
    function int is_empty();
        if(data.size() == 0) begin
            return 1;
        end else return 0;
    endfunction

    // Check if the Queue is almost Empty (25% or less) (1 if true, 0 if false)
    function int is_almost_empty();
        if(data.size() > 63 ) begin
            // $display(" ")
            return 0;
        end else return 1;
    endfunction

    // Check if the Queue is Full (1 if true, 0 if false)
    function int is_full();
        if(data.size() == 256) begin
            return 1;
        end else return 0;
    endfunction

    // Check if the Queue is almost Full (75% or more) (1 if true, 0 if false)
    function int is_almost_full();
        if(data.size() > 192) begin
            return 1;
        end else return 0;
    endfunction

    // Clears the Queue 
    function void clear();
        data = {};
        prev_data = 16'h0000;
        // for (int i = 0; i < 256; i = i +1) begin
        //     data.pop_front();
        // end
    endfunction

endclass