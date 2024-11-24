module InstructionMemory(
    input [31:0] address,         
    output reg [31:0] instruction 
);

    parameter MEM_SIZE = 1024;
    parameter WORD_SIZE = 32;
    parameter BYTE_SIZE = 8;

    reg [7:0] memory [0:MEM_SIZE-1]; 

    initial begin

        
        //000000_00010_00101_01111_00000_100000
        //Suma de la direccion 3 y 5 y se guarda en la direccion 10
        //add $10, $2, $5
        memory[0] = 8'b00000000;  
        memory[1] = 8'b01000101;  
        memory[2] = 8'b01111000;  
        memory[3] = 8'b00100000;   
        
        //001000_00001_01101_0000000000110000
        //addi $13, $1, #48
        //      rt, rs, imm
        memory[4] = 8'b00100000;
        memory[5] = 8'b00101101;
        memory[6] = 8'b00000000;
        memory[7] = 8'b00110000;

        //100011_00110_01001_0000000000000101
        //lw $9, 6($5)
        //     rt, rs, imm
        memory[8] = 8'b10001100;
        memory[9] = 8'b11001001;
        memory[10] = 8'b00000000;
        memory[11] = 8'b00000101;
        
        //101011_00110_01100_0000000000001010
        //sw $12, 6($10)
        //    rt, rs, imm
        memory[12] = 8'b10101100;
        memory[13] = 8'b11001100;
        memory[14] = 8'b00000000;
        memory[15] = 8'b00001010;

        //000100_01000_01010_000000000000011
        //beq $8, $10, 3
        //     rs, rt, imm
        memory[16] = 8'b00010001;
        memory[17] = 8'b00001010;
        memory[18] = 8'b00000000;
        memory[19] = 8'b00000011;
        //Aqui es el Salto a 111111...

        memory[20] = 8'b00000000;
        memory[21] = 8'b00000000;
        memory[22] = 8'b00000000;
        memory[23] = 8'b00000000;

        memory[24] = 8'b00000000;
        memory[25] = 8'b00000000;
        memory[26] = 8'b00000000;
        memory[27] = 8'b00000000;

        memory[28] = 8'b00000000;
        memory[29] = 8'b00000000;
        memory[30] = 8'b00000000;
        memory[31] = 8'b00000000;

        memory[32] = 8'b11111111;
        memory[33] = 8'b11111111;
        memory[34] = 8'b11111111;
        memory[35] = 8'b11111111;


    end

    // Lectura de instrucción con verificación de alineación
    always @(*) begin
        if (address % 4 != 0) begin
            $display("Warning: Unaligned memory access at address %h", address);
            instruction = 32'b0; // En caso de error, devuelve NOP
        end else begin
            instruction = {
                memory[address],     // Byte más significativo (31:24)
                memory[address + 1], // Bytes (23:16)
                memory[address + 2], // Bytes (15:8)
                memory[address + 3]  // Byte menos significativo (7:0)
            };
        end
    end

endmodule