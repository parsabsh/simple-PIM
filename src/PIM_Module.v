module PIM_Module #(parameter DATA_WIDTH=32, ADDR_WIDTH=10) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr_a, addr_b, addr_result, // operand addresses
    input wire [2:0] opcode, // 100: write 'write_data' to 'addr_result', 111: read 'addr_a'
    input wire [DATA_WIDTH-1:0] write_data,
    output wire [DATA_WIDTH-1:0] result
);
    wire [DATA_WIDTH-1:0] a, b, mem_write_data, alu_result;
    wire [1:0] alu_op;
    wire we, write_pim_not, read_pim_not;

    assign mem_write_data = write_pim_not ? write_data : alu_result;
    assign result = read_pim_not ? a : {DATA_WIDTH{1'bz}};
    
    SRAM sram (
        .clk(clk),
        .we(we),
        .write_addr(addr_result),
        .write_data(mem_write_data),
        .read_addr1(addr_a),
	.read_addr2(addr_b),
	.read_data1(a),
	.read_data2(b)
    );

    ALU alu (
        .a(a),
        .b(b),
        .op(alu_op),
        .result(alu_result)
    );

    CU cu (
	.opcode(opcode),
	.alu_op(alu_op),
	.write_pim_not(write_pim_not),
	.read_pim_not(read_pim_not),
	.write_enable(we)
    );
endmodule

