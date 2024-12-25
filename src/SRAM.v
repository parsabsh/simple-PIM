module SRAM #(parameter ADDR_WIDTH = 10, DATA_WIDTH = 32) (
    input wire clk,
    input wire we, 
    input wire [ADDR_WIDTH-1:0] write_addr, read_addr1, read_addr2,
    input wire [DATA_WIDTH-1:0] write_data,
    output wire [DATA_WIDTH-1:0] read_data1, read_data2
);
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge clk) begin
        if (we) 
            mem[write_addr] <= write_data; 
    end
    
    assign read_data1 = mem[read_addr1];
    assign read_data2 = mem[read_addr2];
endmodule

