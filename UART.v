module UART (
    output  wire            o_serial_data,
    output  wire            o_busy,

    input   wire    [7:0]   i_p_data,
    input   wire            i_parity_enable,
    input   wire            i_parity_type,
    input   wire            i_data_valid,
    input   wire            i_clk,
    input   wire            i_rst
);

//internal connections
wire    i_count_done_c;
wire    o_shift_c;
wire    o_load_c;
wire    o_count_c;
wire    o_data_bit_c;
wire    o_parity_bit_c;
wire   [2:0]   o_sel_c;

//instantiations
control_unit UO_control_unit (
    .i_data_valid(i_data_valid),
    .i_count_done(i_count_done_c),
    .i_parity_enable(i_parity_enable),
    .i_clk(i_clk),
    .i_rst(i_rst),

    .o_sel(o_sel_c),
    .o_busy(o_busy),
    .o_count(o_count_c),
    .o_load(o_load_c),
    .o_shift(o_shift_c)
);

serializer U0_serializer (
    .i_p_data(i_p_data),
    .i_shift(o_shift_c),
    .i_load(o_load_c),
    .i_clk(i_clk),
    .i_rst(i_rst),

    .o_data_bit(o_data_bit_c)
);

clocks_counter UO_clocks_counter (
    .i_count_enable(o_count_c),
    .i_clk(i_clk),
    .i_rst(i_rst),
    
    .o_count_done(i_count_done_c)
);

parity U0_parity (
    .i_parity_type(i_parity_type),
    .i_data_bits(i_p_data),

    .o_parity_bit(o_parity_bit_c)
);

mux  U0_mux (
    .i_parity_bit(o_parity_bit_c),
    .i_data_bit(o_data_bit_c),
    .i_sel(o_sel_c),

    .o_serial_data(o_serial_data)
);
    
endmodule