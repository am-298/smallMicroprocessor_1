`timescale 1ns / 1ps
module data_memory(
    input clk, we,
    input [15:0] addr,
    input [15:0] write_data,
    output [15:0] read_data
);
reg [15:0] mem [0:15];

assign read_data = mem[addr];

always @(posedge clk) begin
    if (we)
        mem[addr] <= write_data;
end
endmodule
