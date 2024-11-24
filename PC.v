`timescale 1ns/1ns

module PC(
    input wire clk,
    input wire rst,                 
    input wire [31:0] pc_In,
    output reg [31:0] pc_Out
);

    // Valor inicial para el PC
    parameter RESET_VALUE = 32'h0000_0000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_Out <= RESET_VALUE;  // Reset síncrono
        end else begin
            pc_Out <= pc_In;
        end
    end

endmodule