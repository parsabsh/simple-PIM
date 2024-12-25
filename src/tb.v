module tb;

reg clk;
reg [9:0] addr_a, addr_b, addr_result;
reg signed [31:0] write_data;
reg [2:0] opcode;
wire signed [31:0] result;

PIM_Module dut (
	.clk(clk),
	.addr_a(addr_a),
	.addr_b(addr_b),
	.addr_result(addr_result),
	.opcode(opcode),
	.write_data(write_data),
	.result(result)
);

always #5 clk = ~clk;

initial begin

{clk, addr_a, addr_b, addr_result, write_data} = 0;
opcode = 3'b101;  // no op

// write 20 to 0x000
#4
opcode = 3'b100;
addr_result = 10'h0;
write_data = 32'd20;

// read 0x000
#10
opcode = 3'b111;
addr_a = 10'h0;
#5 $display("value at address 0x%h is %d (a)", addr_a, result);

// write 91 to 0x3FF
#5
opcode = 3'b100;
addr_result = 10'h3FF;
write_data = 32'd91;

// read 0x3FF
#10
opcode = 3'b111;
addr_a = 10'h3FF;

#5 $display("value at address 0x%h is %d (b)", addr_a, result);

// write 0x7FFFFFFF to 0x001
#5
opcode = 3'b100;
addr_result = 10'h001;
write_data = 32'h7FFFFFFF;

// read 0x001
#10
opcode = 3'b111;
addr_a = 10'h001;

#5 $display("value at address 0x%h is %d (max int)", addr_a, result);

// write 0x80000000 to 0x002
#5
opcode = 3'b100;
addr_result = 10'h002;
write_data = 32'h80000000;

// read 0x002
#10
opcode = 3'b111;
addr_a = 10'h002;

#5 $display("value at address 0x%h is %d (min int)", addr_a, result);

// store mem[0x000] + mem[0x3FF] at address 0x100
#5
opcode = 3'b000; // add opcode
addr_a = 10'h000;
addr_b = 10'h3FF;
addr_result = 10'h100;

// store mem[0x000] - mem[0x3FF] at address 0x101
#10
opcode = 3'b001; // subtract opcode
addr_result = 10'h101;

// store mem[0x000] & mem[0x3FF] at address 0x102
#10
opcode = 3'b010; // subtract opcode
addr_result = 10'h102;

// store mem[0x000] | mem[0x3FF] at address 0x103
#10
opcode = 3'b011; // subtract opcode
addr_result = 10'h103;

// store invalid opcode at address 0x104
#10
opcode = 3'b110; // invalid opcode
addr_result = 10'h104;

// store mem[0x000] + mem[0x001] at address 0x105
#10
opcode = 3'b000;
addr_b = 10'h001;
addr_result = 10'h105;

// store mem[0x002] - mem[0x000] at address 0x106
#10
opcode = 3'b001;
addr_a = 10'h002;
addr_b = 10'h0;
addr_result = 10'h106;

// read locations 0x100-0x106 
#10
opcode = 3'b111;
addr_a = 10'h100;
#5 $display("value at address 0x%h is %d => a + b", addr_a, result);

#5
addr_a = 10'h101;
#5 $display("value at address 0x%h is %d => a - b", addr_a, result);

#5
addr_a = 10'h102;
#5 $display("value at address 0x%h is %d => a & b", addr_a, result);

#5
addr_a = 10'h103;
#5 $display("value at address 0x%h is %d => a | b", addr_a, result);

#5
addr_a = 10'h104;
#5 $display("value at address 0x%h is %d => invalid opcode (no op)", addr_a, result);

#5
addr_a = 10'h105;
#5 $display("value at address 0x%h is %d => a + max int (overflow)", addr_a, result);

#5
addr_a = 10'h106;
#5 $display("value at address 0x%h is %d => min int - a (underflow)", addr_a, result);

end

endmodule;
