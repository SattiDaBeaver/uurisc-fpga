module tb_alu;
    parameter DATA_WIDTH = 16;

    enum logic [DATA_WIDTH - 1 : 0] { 
        ADD, SUB, SRL, SLL, OR, NOR, AND, NAND, XOR
    };

    // Wires
    logic [DATA_WIDTH - 1 : 0]   alu_a_in;
    logic [DATA_WIDTH - 1 : 0]   alu_b_in;
    logic [DATA_WIDTH - 1 : 0]   alu_op;

    logic [DATA_WIDTH - 1 : 0]   alu_dout;
    logic [DATA_WIDTH - 1 : 0]   alu_flags;

    // dut
    ALU # (
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .alu_a_in(alu_a_in),
        .alu_b_in(alu_b_in),
        .alu_op(alu_op),

        .alu_dout(alu_dout),
        .alu_flags(alu_flags)
    );

    integer i;
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, tb_alu);

        alu_a_in = 16'h355;
        alu_b_in = 16'h5;

        for (i = 0; i < 9; i = i + 1) begin
            #5
            alu_op = i;
            $display("A = %04H, B = %04H, OP = %04H, OUT = %04H, flags: %04H", alu_a_in, alu_b_in, alu_op, alu_dout, alu_flags);
        end
        $finish;
    end


endmodule