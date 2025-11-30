module dp_ram #(
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH = 4096,
    parameter ADDR_WIDTH = $clog2(MEM_DEPTH)
) (
    input  logic            clk,

	input  logic [DATA_WIDTH - 1 : 0] din_a,
    input  logic [ADDR_WIDTH - 1 : 0] addr_a,
    input  logic                      we_a,
    output logic [DATA_WIDTH - 1 : 0] dout_a,

	input  logic [DATA_WIDTH - 1 : 0] din_b,
    input  logic [ADDR_WIDTH - 1 : 0] addr_b,
    input  logic                      we_b,
    output logic [DATA_WIDTH - 1 : 0] dout_b
);
    
    // Memory
    logic [DATA_WIDTH - 1 : 0] mem [0 : MEM_DEPTH - 1];

    always_ff @ (posedge clk) begin
        if (we_a) begin
            mem[addr_a] <= din_a;
        end
        if (we_b) begin
            mem[addr_b] <= din_b;
        end
    end

    always_comb begin
        dout_a = mem[addr_a];
        dout_b = mem[addr_b];
    end    
endmodule