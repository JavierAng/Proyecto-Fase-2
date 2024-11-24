`timescale 1ns/1ns

module sign_extend(
    input [15:0] in,      // Entrada de 16 bits
    output [31:0] out     // Salida extendida a 32 bits
);

    assign out = {{16{in[15]}}, in}; // Extensión del signo

endmodule
