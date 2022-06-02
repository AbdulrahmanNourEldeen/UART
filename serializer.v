module serializer (
    output  wire            o_data_bit,
    
    input   wire    [7:0]   i_p_data,
    input   wire            i_shift,
    input   wire            i_load,
    input   wire            i_clk,
    input   wire            i_rst
);
    reg  [7:0]   data;
    wire [7:0]   data_next;

    always @(posedge i_clk or negedge i_rst) 
        begin
            if(!i_rst)
                begin
                    data <= 8'b0;
                end
            else if (i_load)
                begin
                    data <= i_p_data;
                end 
            else if (i_shift)
                begin
                    data <= data_next;
                end
        end

    assign  o_data_bit  = data[0]; // sending the LSB first
    assign  data_next   = (data >> 1);
    
endmodule