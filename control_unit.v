module control_unit (
    output  reg    [2:0]   o_sel,
    output  reg            o_busy,
    output  reg            o_count,
    output  reg            o_load,
    output  reg            o_shift,

    input   wire            i_data_valid,
    input   wire            i_count_done,
    input   wire            i_parity_enable,
    input   wire            i_clk,
    input   wire            i_rst
);
    reg [2:0]   current_state;
    reg [2:0]   next_state;

    localparam  [2:0]   IDLE    = 3'b001,
                        LOAD    = 3'b010,
                        START   = 3'b011,
                        DATA    = 3'b100,
                        PARITY  = 3'b101,
                        STOP    = 3'b110;

//state transition
    always @(posedge i_clk or negedge i_rst) 
        begin
            if(!i_rst)
                begin
                    current_state <= IDLE;
                end
            else
                begin
                    current_state <= next_state;
                end
        end

//next state logic
    always @(*) 
        begin
            case(current_state)
                IDLE:
                    begin
                        if(!i_data_valid)
                            begin
                                next_state = IDLE;
                            end
                        else
                            begin
                                next_state = LOAD;
                            end
                    end
                LOAD:
                    begin
                        next_state = START;
                    end
                START:
                    begin
                        next_state = DATA;
                    end
                DATA:
                    begin
                        if(i_count_done)
                            begin
                                if(i_parity_enable)
                                    begin
                                        next_state = PARITY;
                                    end
                                else
                                    begin
                                        next_state = STOP;
                                    end
                            end
                        else
                            begin
                                next_state = DATA;
                            end
                    end
                PARITY:
                    begin
                        next_state = STOP;
                    end
                STOP:
                    begin
                        next_state = IDLE;
                    end 
            endcase
        end

// output logic
   always @(*) 
        begin
            case(current_state)
                IDLE:
                    begin
                        o_sel   = 3'b000;
                        o_busy  = 1'b0;
                        o_count = 1'b0; 
                        o_load  = 1'b0;
                        o_shift = 1'b0;
                    end
                LOAD:
                    begin
                        o_sel   = 3'b000;
                        o_busy  = 1'b0;
                        o_count = 1'b0; 
                        o_load  = 1'b1;
                        o_shift = 1'b0;
                    end
                START:
                    begin
                        o_sel   = 3'b001;
                        o_busy  = 1'b1;
                        o_count = 1'b0; 
                        o_load  = 1'b0;
                        o_shift = 1'b0;
                    end
                DATA:
                    begin
                        o_sel   = 3'b010;
                        o_busy  = 1'b1;
                        o_count = 1'b1; 
                        o_load  = 1'b0;
                        o_shift = 1'b1;
                    end
                PARITY:
                    begin
                        o_sel   = 3'b011;
                        o_busy  = 1'b1;
                        o_count = 1'b0; 
                        o_load  = 1'b0;
                        o_shift = 1'b0;
                    end
                STOP:
                    begin
                        o_sel   = 3'b100;
                        o_busy  = 1'b1;
                        o_count = 1'b0; 
                        o_load  = 1'b0;
                        o_shift = 1'b0;
                    end 
            endcase
        end
endmodule