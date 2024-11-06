module Control_unit(OpCode, Funct3, Funct7, RUWr, ImmSrc, AluASrc, AluBSrc, BrOp, ALUOp, DMWr, DMCtrl, RUDataWrSrc, DMRd);
  input logic [6:0]OpCode;
  input logic [2:0]Funct3;
  input logic [6:0]Funct7;
  output logic RUWr;
  output logic [2:0]ImmSrc;
  output logic AluASrc;
  output logic AluBSrc;
  output logic [4:0]BrOp;
  output logic [3:0]ALUOp;
  output logic DMWr;
  output logic DMRd;
  output logic [2:0]DMCtrl;
  output logic [1:0]RUDataWrSrc;
  
  
				
  always_comb begin
  
  RUWr = 0;
  ImmSrc = 3'b000;
  AluASrc = 0;
  AluBSrc = 0;
  BrOp = 5'b00000;			//Inicializacion de todas las salidas en 0
  ALUOp = 4'b0000;
  DMWr = 0;
  DMCtrl = 3'b000;
  RUDataWrSrc = 2'b00;
  DMRd = 0;
  
    case(OpCode)
      7'b0110011 : RUWr = 1;	//Instrucción tipo R
      7'b0010011 : begin
        RUWr = 1;
        AluBSrc = 1;			//Instrucción tipo I
      end	
      7'b0000011 : begin
        RUWr = 1;
        AluBSrc = 1;
        DMRd = 1; 				//Instrucción de lectura de memoria tipo I
        RUDataWrSrc = 2'b01;
      end
      7'b1100111 : begin
        RUWr = 1;
        AluBSrc = 1;			//Instrucción de salto tipo I (jalr)
        BrOp = 5'b10000;
        RUDataWrSrc = 2'b10;
      end
      7'b1100011 : begin
        ImmSrc = 3'b101;
        AluASrc = 1;			//Instrucción de tipo B
        AluBSrc = 1;			
      end
      7'b0100011 : begin
        ImmSrc = 3'b001;
        AluBSrc = 1;			//Instrucción de tipo S
        DMWr = 1;
      end
      7'b1101111 : begin
        RUWr = 1;
        ImmSrc = 3'b110;
        AluASrc = 1;			//Instrucción de tipo j (jal)
        AluBSrc = 1;			
        BrOp = 5'b10000;			
        RUDataWrSrc = 2'b10;
      end
      7'b0110111 : begin
        RUWr = 1;
        ImmSrc = 3'b010;		//Instrucción de tipo u (lui)
        AluBSrc = 1;					
        ALUOp = 4'b0111;
      end
      7'b0010111 : begin
        RUWr = 1;
        ImmSrc = 3'b010;
        AluASrc = 1;			//Instrucción de tipo u (auipc)
        AluBSrc = 1;			
        BrOp = 5'b10000;			
        RUDataWrSrc = 2'b10;
      end
      default: begin
        RUWr = 0;
        ImmSrc = 3'b000;
        AluASrc = 0;
        AluBSrc = 0;
        BrOp = 5'b00000;			//Valor por defecto
        ALUOp = 4'b0000;
        DMWr = 0;
        DMCtrl = 3'b000;
        RUDataWrSrc = 2'b00;
      end
    endcase
    if (OpCode == 7'b0110011) begin
        case({Funct3,Funct7})
          10'b0000000000 : ALUOp = 4'b0000; //A + B add
          10'b0000100000 : ALUOp = 4'b1000; //A - B sub
          10'b0010000000 : ALUOp = 4'b0001; //A << B sll
          10'b0100000000 : ALUOp = 4'b0010; //A < B slt
          10'b0110000000 : ALUOp = 4'b0011; //A < B (Sin signo) sltu
          10'b1000000000 : ALUOp = 4'b0100; //A xor B
          10'b1010000000 : ALUOp = 4'b0101; //A >> B srl
          10'b1010100000 : ALUOp = 4'b1101; //A >>> B sra
          10'b1100000000 : ALUOp = 4'b0110; //A or B
          10'b1110000000 : ALUOp = 4'b0111; //A and B
          default : ALUOp = 0000;
        endcase
     end
  
    if (OpCode == 7'b0010011) begin
        case(Funct3)
          3'b000 : ALUOp = 4'b0000; //A + B addi
          3'b001 : ALUOp = 4'b0001; //A << B slli
          3'b010 : ALUOp = 4'b0010; //A < B slti
          3'b011 : ALUOp = 4'b0011; //A < B (Sin signo) sltiu
          3'b100 : ALUOp = 4'b0100; //A xori B
          3'b101 : begin 
            if (Funct7[5]) begin
              ALUOp = 4'b1101; 	  // A >>> B srai
            end else begin
              ALUOp = 4'b0101;  // A >> B srli
            end
          end
          3'b110 : ALUOp = 4'b0110; //A ori B
          3'b111 : ALUOp = 4'b0111; //A andi B
          default : ALUOp = 0000;
        endcase
     end
    if (OpCode == 7'b1100011) begin
        case(Funct3)
          3'b000 : BrOp = 5'b01000; //beq branch equal
          3'b001 : BrOp = 5'b01001; //bne branch not equal
          3'b100 : BrOp = 5'b01100; //blt branch less than
          3'b101 : BrOp = 5'b01101; //bge branch greater equal
          3'b110 : BrOp = 5'b01110; //bltu branch less than unsigned
          3'b111 : BrOp = 5'b01111; //bgeu branch greater equal unsigned
          default : BrOp = 00000;
        endcase
     end
    if (OpCode == 7'b0000011 || OpCode == 7'b0100011) begin
      case(Funct3)
        3'b000 : DMCtrl = 3'b000; //lb Leer byte - sb save byte
        3'b001 : DMCtrl = 3'b001; //lh Leer media palabra - sh save half word 
        3'b010 : DMCtrl = 3'b010; //lw Leer palabra de memoria - sw save word
        3'b100 : DMCtrl = 3'b100; //lbu Leer byte sin signo
        3'b101 : DMCtrl = 3'b101; //lhu Leer media palabra sin signo
        default : DMCtrl = 000;
      endcase
	end
	end
endmodule	