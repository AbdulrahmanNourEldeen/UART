module mux (
    output  reg             o_serial_data,

    input   wire            i_parity_bit,
    input   wire            i_data_bit,
    input   wire    [2:0]   i_sel
);

    localparam  [1:0]   IDLE        = 3'b000,
                        start_bit   = 3'b001,
                        data_bit    = 3'b010,
                        parity_bit  = 3'b011,
                        stop_bit    = 3'b100;

    always @(*) 
        begin
            case(i_sel)
                IDLE:
                    begin
                        o_serial_data = 1'b1;
                    end
                start_bit:
                    begin
                        o_serial_data = 1'b0;   
                    end
                data_bit:
                    begin
                        o_serial_data = i_data_bit;
                    end
                stop_bit:
                    begin
                        o_serial_data = 1'b1;
                    end
                parity_bit:
                    begin
                        o_serial_data = i_parity_bit;
                    end
                default:
                    begin
                        o_serial_data = 1'b1;
                    end 
            endcase
        end
    
endmodule