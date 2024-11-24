`timescale 1ns/1ns

module RAM (
    input [4:0] Dir,
    input [31:0] Datos,
    input WE,
    input RE,

    output reg [31:0] Salida
);
    reg [31:0] Mem [0:63];

    always @* 
    begin
        if (WE) 
        begin
            Mem[Dir] = Datos;
        end
        else if (RE)
        begin
            Salida = Mem[Dir];
        end
    end
endmodule
