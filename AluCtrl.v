`timescale 1ns/1ns

module AluCtrl(
    input [5:0] funct,
    input [2:0] En_UC,
    output reg [2:0] to_Alu
);

    // Parámetros para los códigos de función
    localparam F_AND = 6'b100100;
    localparam F_OR  = 6'b100101;
    localparam F_ADD = 6'b100000;
    localparam F_SUB = 6'b100010;
    localparam F_SLT = 6'b101010;
    localparam F_XOR = 6'b100110;
    localparam F_NOR = 6'b100111;

    // Parámetros para las operaciones de ALU
    localparam ALU_AND = 3'b000;
    localparam ALU_OR  = 3'b001;
    localparam ALU_ADD = 3'b010;
    localparam ALU_XOR = 3'b011;
    localparam ALU_NOR = 3'b100;
    localparam ALU_SUB = 3'b110;
    localparam ALU_SLT = 3'b111;

    always @(*) begin
        case(En_UC)
            3'b010: begin  // Instrucciones tipo R
                case(funct)
                    F_AND: to_Alu = ALU_AND;
                    F_OR:  to_Alu = ALU_OR;
                    F_ADD: to_Alu = ALU_ADD;
                    F_SUB: to_Alu = ALU_SUB;
                    F_SLT: to_Alu = ALU_SLT;
                    F_XOR: to_Alu = ALU_XOR;
                    F_NOR: to_Alu = ALU_NOR;
                    default: to_Alu = 3'b000;  // Operación por defecto
                endcase
            end
            3'b000: to_Alu = ALU_ADD; 
            3'b001: to_Alu = ALU_SUB; // Instrucciones tipo ADDI
        endcase
    end

endmodule