module Banco(
    input [4:0]DL1,
    input [4:0]DL2,
    input [4:0]DE,
    input [31:0]Dato,
    input WE,
    input clk,    
    input rst,    
    output reg[31:0]op1,
    output reg[31:0]op2
);

    reg [31:0]BR [0:31];
    integer i;

    // Escritura síncrona
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                BR[i] <= 32'b0;
            end
        end
        else if (WE && DE != 0) begin  // Proteger registro $zero
            BR[DE] <= Dato;
        end
    end

    // Lectura asíncrona
    always @* begin
        op1 = BR[DL1];
        op2 = BR[DL2];
    end

endmodule