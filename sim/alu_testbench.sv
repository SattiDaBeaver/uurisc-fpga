module tb_alu;
    parameter DATA_WIDTH = 16;

    typedef enum logic [DATA_WIDTH - 1 : 0] { 
        ADD, SUB, SRL, SLL, OR, NOR, AND, NAND, XOR, NOT
    } alu_op_t;

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

        alu_a_in = 16'h358;
        alu_b_in = 16'h5;

        for (i = 0; i < 10; i = i + 1) begin
            alu_op = i;
            #5
            $display("A = %04H, B = %04H, OP = %04H, OUT = %04H, flags: %0B", alu_a_in, alu_b_in, alu_op, alu_dout, alu_flags[2:0]);
            #5;
        end
        $display("A = %04H, B = %04H, OP = %04H, OUT = %04H, flags: %0B", alu_a_in, alu_b_in, alu_op, alu_dout, alu_flags[2:0]);
        $finish;
    end


endmodule