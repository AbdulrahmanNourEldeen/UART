module parity (
    output  wire            o_parity_bit,

    input   wire            i_parity_type,  //0 even parity , 1 odd parity
    input   wire    [7:0]   i_data_bits
);
    assign  o_parity_bit = (i_parity_type)? (^i_data_bits) : ~(^i_data_bits);
endmodule
