module CU (
    input wire [2:0] opcode,
    output wire write_pim_not, read_pim_not, write_enable,
    output wire [1:0] alu_op
);
    assign alu_op = opcode[1:0];
    assign write_pim_not = opcode == 3'b100;
    assign read_pim_not = opcode == 3'b111;
    assign write_enable = (opcode[2] == 0) || write_pim_not;
endmodule

