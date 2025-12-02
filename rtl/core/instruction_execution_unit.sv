module instruction_execution_unit #(
    parameter INSTR_WIDTH       = 32,
    parameter INSTR_ADDR_WIDTH  = 16,
    parameter DATA_WIDTH        = 16,
    parameter DATA_ADDR_WIDTH   = 16,
    parameter PC_MEM_ADDR       = 16'h8000
) (
    input  logic clk,
    input  logic rst,

    // instruction memory interface
    input  logic [INSTR_WIDTH - 1 : 0]      instr_din,
    output logic [INSTR_ADDR_WIDTH - 1 : 0] instr_addr,

    // data memory interface
    input  logic [DATA_WIDTH - 1 : 0]       data_din,
    output logic [DATA_ADDR_WIDTH - 1 : 0]  data_addr,
    output logic                            data_wr,
    output logic [DATA_WIDTH - 1 : 0]       data_dout,

    // debug interface
    input  run,
    output busy
);

    // internal registers
    logic [DATA_WIDTH - 1 : 0]          temp_reg;
    // logic [DATA_ADDR_WIDTH - 1 : 0]     read_addr_reg;
    logic [DATA_ADDR_WIDTH - 1 : 0]     write_addr_reg;
    logic [DATA_ADDR_WIDTH - 1 : 0]     pc_reg;

    // internal wires
    logic [DATA_ADDR_WIDTH - 1 : 0]     next_write_addr;
    logic [DATA_ADDR_WIDTH - 1 : 0]     next_read_addr;

    // wire assignments
    assign instr_addr       = pc_reg;
    assign next_read_addr   = instr_din[DATA_ADDR_WIDTH - 1 : 0];
    assign next_write_addr  =  instr_din[2 * DATA_ADDR_WIDTH - 1 : DATA_ADDR_WIDTH];

    // FSM enum
    typedef enum logic [1:0] { 
        IDLE, FETCH, WRITE
    } 
    state_t;

    state_t curr_state, next_state;

    // state registers
    always_ff @(posedge clk) begin
        if (rst) begin
            curr_state      <= IDLE;
            temp_reg        <= '0;
            // read_addr_reg   <= '0;
            write_addr_reg  <= '0;
            pc_reg          <= '0;
        end
        else begin
            curr_state <= next_state;

            // set registers
            // TODO: Write logic for registers
            case (curr_state)
                FETCH: begin
                    temp_reg        <= data_din;
                    // read_addr_reg   <= next_read_addr;
                    write_addr_reg  <= next_write_addr;
                    if (next_write_addr == PC_MEM_ADDR) begin
                        pc_reg      <= data_din;
                    end
                    else begin
                        pc_reg      <= pc_reg + 1;
                    end
                end

                WRITE: begin
                    
                end

            endcase
        end
    end

    // state table
    always_comb begin
        // defaults
        data_addr = 'b0;
        data_wr   = 1'b0;
        data_dout = temp_reg; 
        next_state = curr_state;

        case (curr_state)
            IDLE: begin 
                if (run)    next_state = FETCH;
                else        next_state = IDLE;
            end

            FETCH: begin
                next_state = WRITE;

                data_addr  = next_read_addr;
            end

            WRITE: begin
                if (run)    next_state = FETCH;
                else        next_state = IDLE;

                data_addr = write_addr_reg;
                data_dout = temp_reg;
                data_wr   = 1'b1;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule