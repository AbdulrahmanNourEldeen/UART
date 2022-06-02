module clocks_counter (
    output  wire    o_count_done,

    input   wire    i_count_enable,
    input   wire    i_clk,
    input   wire    i_rst
);

    reg [2:0]   count;
    reg [2:0]   count_comb;

    always @(posedge i_clk or negedge i_rst) 
        begin
            if(!i_rst)
                begin
                    count <= 3'd0;
                end
            else if (i_count_enable)
                    if(count == 3'd7)
                        begin
                            count <= 3'd0;
                        end
                    else 
                        begin
                            count <= count_comb;
                        end
        end

    always @(*) 
        begin
            count_comb = count + 1'd1;
        end

    assign o_count_done = (count == 3'd7);

endmodule