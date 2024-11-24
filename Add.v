`timescale 1ns/1ns

module ADD(
    input[31:0] A,
    input[31:0] B,
    output[31:0] suma
);

assign suma = A+B;

endmodule