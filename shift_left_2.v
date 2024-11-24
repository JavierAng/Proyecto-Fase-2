`timescale 1ns/1ns

module shift_left_2 (
    input [31:0] in,      // Entrada de 32 bits
    output [31:0] out     // Salida de 32 bits
);

    assign out = in << 2; // Desplazamiento a la izquierda por 2 posiciones

endmodule
