module instruction_execution_unit #(
    parameter INSTR_WIDTH       = 32,
    parameter INSTR_ADDR_WIDTH  = 16,
    parameter DATA_WIDTH        = 32,
    parameter DATA_ADDR_WIDTH   = 16
) (
    input  logic clk,
    input  logic rst,

    // instruction memory interface
    input  logic [INSTR_WIDTH - 1 : 0]      instr_din,
    input  logic [INSTR_ADDR_WIDTH - 1 : 0] instr_addr,

    // data memory interface
    input  logic [DATA_WIDTH - 1 : 0]       data_din,
    input  logic [DATA_ADDR_WIDTH - 1 : 0]  data_addr,
    input  logic                            data_wr,
    output logic [DATA_WIDTH - 1 : 0]       data_dout,

    // debug interface
    input  run,
    output busy
);

    // internal registers
    logic [DATA_WIDTH - 1 : 0]          temp_reg;
    logic [DATA_ADDR_WIDTH - 1 : 0]     read_addr_reg;
    logic [DATA_ADDR_WIDTH - 1 : 0]     write_addr_reg;
    logic [DATA_ADDR_WIDTH - 1 : 0]     pc_reg;

    // FSM enum
    typedef enum logic [1:0] { 
        IDLE, INIT, FETCH, EXEC
    } 
    state_t;

    state_t curr_state, next_state;

    // state registers
    always_ff @(posedge clk) begin
        if (rst) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;

            // set registers
            // TODO: Write logic for registers
        end
    end

    // state table
    always_comb begin
        case (curr_state)
            IDLE: begin 
                if (run) begin
                    next_state = INIT;
                end
                else begin
                    next_state = IDLE;
                end
            end

            INIT: begin
                next_state = FETCH;
            end

            FETCH: begin
                next_state = EXEC;
            end

            EXEC: begin
                if (run) begin
                    next_state = FETCH;
                end
                else begin
                    next_state = IDLE;
                end
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
endmodule