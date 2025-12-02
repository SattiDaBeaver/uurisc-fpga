`timescale 1ns/1ps

module tb_ieu;

    // parameters (match your design)
    localparam INSTR_WIDTH      = 32;
    localparam INSTR_ADDR_WIDTH = 16;
    localparam DATA_WIDTH       = 16;
    localparam DATA_ADDR_WIDTH  = 16;
    localparam PC_MEM_ADDR      = 16'h8000;

    // DUT signals
    logic clk, rst, run;
    logic [INSTR_WIDTH-1:0] instr_din;
    logic [INSTR_ADDR_WIDTH-1:0] instr_addr;

    logic [DATA_WIDTH-1:0] data_din;
    logic [DATA_ADDR_WIDTH-1:0] data_addr;
    logic data_wr;
    logic [DATA_WIDTH-1:0] data_dout;

    // simple instruction memory
    logic [INSTR_WIDTH-1:0] instr_mem [0:255];

    // simple data memory
    logic [DATA_WIDTH-1:0] data_mem [0:65535];

    // clock
    always #5 clk = ~clk;

    // DUT
    instruction_execution_unit #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .INSTR_ADDR_WIDTH(INSTR_ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
        .PC_MEM_ADDR(PC_MEM_ADDR)
    ) dut (
        .clk(clk),
        .rst(rst),

        .instr_din(instr_din),
        .instr_addr(instr_addr),

        .data_din(data_din),
        .data_addr(data_addr),
        .data_wr(data_wr),
        .data_dout(data_dout),

        .run(run),
        .busy()
    );

    // instruction fetch
    assign instr_din = instr_mem[instr_addr];

    // data read
    assign data_din = data_mem[data_addr];

    // data write
    always_ff @(posedge clk) begin
        if (data_wr)
            data_mem[data_addr] <= data_dout;
    end

    // helper task
    task show_state(string label);
        $display("[%0t] %s | PC=%0d | RADDR=%0d | WADDR=%0d | temp=%0d | WR=%b | DOUT=%0d",
                 $time, label, instr_addr, data_addr, dut.write_addr_reg, dut.temp_reg,
                 data_wr, data_dout);
    endtask


    integer i;
    initial begin
        // dumpfile
        $dumpfile("ieu_tb.vcd");
        $dumpvars(0, tb_ieu);
        // init
        clk = 0;
        rst = 1;
        run = 0;

        // preload data memory
        data_mem[0] = 16'hFFFF;
        data_mem[1] = 16'h1234;
        data_mem[2] = 16'hABCD;
        data_mem[3] = 16'h5555;
        data_mem[4] = 16'hC0FE;
        data_mem[5] = 16'h0005;

        // instruction format: {write_addr, read_addr}
        instr_mem[0] = {16'd10, 16'd1};

        instr_mem[1] = {16'd12, 16'd2};

        instr_mem[2] = {PC_MEM_ADDR, 16'd5};

        instr_mem[3] = 16'h0000;
        instr_mem[4] = 16'h0000;

        // instr_mem[0BAD] (after jump): read 30 → write 300
        instr_mem[5] = {16'd7, 16'd5};

        #30 rst = 0;

        // start execution
        run = 1;

        repeat (20) begin
            @(posedge clk);
            show_state("step");
        end

        // verify writes
        for (i = 0; i < 16; i = i + 1) begin
            $display("data_mem[%0d] = %04h", i, data_mem[i]);
        end
        $display("data_mem[%0d] = %04h", PC_MEM_ADDR, data_mem[PC_MEM_ADDR]);

        $finish;
    end

endmodule
