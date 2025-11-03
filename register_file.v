`timescale 1ns / 1ps
module register_file(
    input clk,
    input we,
    input [4:0] write_reg, read_reg1, read_reg2,
    input [15:0] write_data,
    output [15:0] read_data1,
    output [15:0] read_data2
);
reg [15:0] regs [0:31];

assign read_data1 = regs[read_reg1];
assign read_data2 = regs[read_reg2];

always @(posedge clk) begin
    if (we)
        regs[write_reg] <= write_data;
end
endmodule
