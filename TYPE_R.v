`timescale 1ns/1ns

module ISA(
    input clk,
    output [31:0] salida
);

    // Entrada de instrucciones obtenida de la memoria de instrucciones
    wire [31:0] instruccion;

    // Banco de registros
    wire [31:0] d1BR_Op1Alu;
    wire [31:0] d2BR_Op2Alu;

    // Mux para seleccionar dato de memoria o registro
    wire [31:0] Dato_Mem_to_BR;

    // ALU
    wire [31:0] Resultado_Alu;
	wire flagToAnd;

    // Unidad de control
    wire BR_Enabler;
    wire [2:0] AluControl;
    wire MemW;
    wire MemR;
    wire Mem_to_BR;
	wire branchToAnd;
	wire regDestino;
	wire aluSource;

    // Memoria de datos
    wire [31:0] MemD;

    // ALU Control
    wire [2:0] AluCtrl2Alu;

    // Contador de programa (PC)
    wire [31:0] DireccionParaMemInstr;
    wire rst;

	//add
    wire [31:0] SumaToMux;
	//mux
	wire [31:0] muxtoPc;
	//Cables para and
	wire andtomux;
    //Cable del mux del br
	wire [31:0]muxtoBR;
    //Cable del mux a la alu
	wire [31:0]muxToAlu;
    //Cable del sign extend al mux
    wire [31:0] SignToMux;  

    wire [31:0] shiftToAdd;
    wire [31:0] SumaBranchToMux;



    // Instancia de la Unidad de Control
    U_control UC (
        .Opcode(instruccion[31:26]),
        .BR_En(BR_Enabler),
        .AluC(AluControl),
        .EnR(MemR),
        .EnW(MemW),
        .Mux1(Mem_to_BR),
		.Branch(branchToAnd),
		.regDest(regDestino),
		.AluSRC(aluSource)
    );

    // Instancia del Banco de Registros
    Banco instBanco (                // Agregar conexión del reset
        .DL1(instruccion[25:21]),
        .DL2(instruccion[20:16]),
        .DE(muxtoBR[4:0]),
        .Dato(Dato_Mem_to_BR),
        .WE(BR_Enabler),
        .op1(d1BR_Op1Alu),
        .op2(d2BR_Op2Alu),
        .clk(clk),
        .rst(rst)
);

    // Instancia de la ALU
    ALU instAlu (
        .Ope1(d1BR_Op1Alu),
        .Ope2(muxToAlu),
        .AluOp(AluCtrl2Alu),
        .Resultado(Resultado_Alu),
		.zero(flagToAnd),
        .rst(rst)
    );

    // Instancia del Mux para seleccionar entre Resultado de ALU y Memoria
    Mux2_1 muxMemToReg (
        .sel(Mem_to_BR),
        .A(MemD),
        .B(Resultado_Alu), // Conectar a MemD en vez de Resultado_Alu, si corresponde al dato de memoria
        .C(Dato_Mem_to_BR)
    );

    // Instancia del Controlador de ALU
    AluCtrl aluCTRL (
        .funct(instruccion[5:0]),
        .En_UC(AluControl),
        .to_Alu(AluCtrl2Alu)
    );

    // Instancia de la Memoria de Instrucciones
    InstructionMemory MemoriaDeInstrucciones (
        .address(DireccionParaMemInstr),
        .instruction(instruccion) // Conectar salida de instrucciones a la señal `instruccion`
    );

    // Instancia del PC (Contador de Programa)
    PC pc (
        .clk(clk),
        .rst(rst),
        .pc_In(muxtoPc),
        .pc_Out(DireccionParaMemInstr)
    );

    // Instancia del Sumador para el PC
    ADD sumadorPC (
        .A(DireccionParaMemInstr),
        .B(32'b000000_00000_00000_00000_00000_000100), // Incremente de 4 bytes
        .suma(SumaToMux)
    );

	Mux2_1 muxAdd (
		.sel(andtomux),
        .A(SumaBranchToMux),
        .B(SumaToMux), // Conectar a MemD en vez de Resultado_Alu, si corresponde al dato de memoria
        .C(muxtoPc)
	);

	AndModule andBranch(
		.a(branchToAnd),
		.b(flagToAnd),
		.out(andtomux)
	);

	Mux2_1 muxBR (
        .sel(regDestino),
        .A({27'b0, instruccion[15:11]}), // Seleccionar el registro rt
        .B({27'b0, instruccion[20:16]}), // Seleccionar el registro rs
        .C(muxtoBR)
    );  

	Mux2_1 muxAlu (
		.sel(aluSource),
        .A(SignToMux),
        .B(d2BR_Op2Alu), 
        .C(muxToAlu)
	);

    sign_extend SE (
        .in(instruccion[15:0]),
        .out(SignToMux)
    );

    RAM MemoriaDeDatos (
        .Dir(Resultado_Alu[4:0]),
        .Datos(d2BR_Op2Alu),
        .WE(MemW),
        .RE(MemR),
        .Salida(MemD)
    );     

    shift_left_2 SL2 (
        .in(SignToMux),
        .out(shiftToAdd)
    );

    ADD ADD2 (
        .A(SumaToMux),
        .B(shiftToAdd),
        .suma(SumaBranchToMux)
    );

endmodule


