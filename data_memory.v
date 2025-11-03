`timescale 1ns / 1ps
module control_unit(
    input clk, reset, stop_signal,
    output reg [2:0] state
);
parameter IDLE=0, FETCH=1, DECODE=2, EXECUTE=3, HALT=4;
reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if (reset)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    case (state)
        IDLE: next_state = FETCH;
        FETCH: next_state = DECODE;
        DECODE: next_state = EXECUTE;
        EXECUTE: next_state = stop_signal ? HALT : FETCH;
        HALT: next_state = HALT;
        default: next_state = IDLE;
    endcase
end
endmodule
