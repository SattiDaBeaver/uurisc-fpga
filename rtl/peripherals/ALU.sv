module ALU #(
    parameter DATA_WIDTH = 16
) (
    input  logic [DATA_WIDTH - 1 : 0]   alu_a_in,
    input  logic [DATA_WIDTH - 1 : 0]   alu_b_in,
    input  logic [DATA_WIDTH - 1 : 0]   alu_op,

    output logic [DATA_WIDTH - 1 : 0]   alu_dout,
    output logic [DATA_WIDTH - 1 : 0]   alu_flags,
);

    enum logic [DATA_WIDTH - 1 : 0] { 
        ADD, SUB, SRL, SLL, OR, NOR, AND, NAND, XOR
    };

    logic n_flag, z_flag, c_flag;
    logic [DATA_WIDTH : 0] alu_result;

    assign alu_dout = alu_result[DATA_WIDTH - 1 : 0];
    assign alu_flags[2:0] = {c_flag, n_flag, z_flag};
    assign alu_flags[DATA_WIDTH - 1 : 3] = 'h0;

    always @ (*) begin
        n_flag = (alu_dout < 0);
        z_flag = (alu_dout == 0);
        c_flag = alu_result[DATA_WIDTH];

        case (alu_op)
            ADD:        alu_result = A + B;
            SUB:        alu_result = A - B;
            SRL:        alu_result = A >> B; // might want to change B width
            SLL:        alu_result = A << B; // might want to change A width
            OR:         alu_result = A | B;
            NOR:        alu_result = ~(A | B);
            AND:        alu_result = A & B;
            NAND:       alu_result = ~(A & B);
            XOR:        alu_result = A ^ B;

            default:    alu_result = 'h0;
        endcase
    end
    
endmodule