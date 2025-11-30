module sram #(
    parameter DATA_WIDTH = 16,
    parameter MEM_DEPTH  = 65536,
    parameter ADDR_WIDTH = $clog2(MEM_DEPTH)
) (
    input  logic                        clk,
    input  logic [DATA_WIDTH - 1 : 0]   din,
    input  logic [ADDR_WIDTH - 1 : 0]   addr,
    input  logic                        wr_en,

    output logic [DATA_WIDTH - 1 : 0]   dout
);

    // Memory 
    logic [DATA_WIDTH - 1 : 0] mem [0 : MEM_DEPTH - 1];

    always_ff @(posedge clk) begin
        if (wr_en) begin
            mem[addr] <= din;
        end
    end

    assign dout = mem[addr];    
endmodule