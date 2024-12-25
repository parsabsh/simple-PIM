module ALU #(parameter DATA_WIDTH = 32)  (
    input wire [DATA_WIDTH-1:0] a, b,
    input wire [1:0] op,
    output reg [DATA_WIDTH-1:0] result 
);
    always @(*) begin
        case (op)
            2'b00: result = a + b; 
            2'b01: result = a - b; 
            2'b10: result = a & b; 
            2'b11: result = a | b;
            default: result = {DATA_WIDTH{1'b0}};
        endcase
    end
endmodule
