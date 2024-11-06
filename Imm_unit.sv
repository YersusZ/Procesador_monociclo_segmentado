module Imm_unit(ImmIn, ImmSrc, ImmExt);
	input logic [24:0]ImmIn;
	input logic [2:0]ImmSrc; 			// Declaracion de las entradas y salidas
	output logic [31:0]ImmExt;
	always @* begin
		if(ImmIn[24] == 0) begin  // Revisa si es complemento a2 con el bit mas significativo
			ImmExt = 32'b0;        // Rellena el arreglo de la salida con 0 cuando no es complemento a2
		end
		else begin
			ImmExt = 32'hFFFFFFFF; // Rellena el arreglo de la salida con 1 cuando es complemento a2
		end
		case(ImmSrc)
				3'b000 : ImmExt[11:0] <= ImmIn[24:13];                        								//Tipo I
				3'b001 : ImmExt[11:0] <= {ImmIn[24:18],ImmIn[4:0]};											//Tipo S
				3'b101 : ImmExt[12:0] <= {ImmIn[24], ImmIn[0], ImmIn[23:18], ImmIn[4:1], 1'b0};				//Tipo B
				3'b010 : ImmExt[19:0] <= ImmIn[24:5];														//Tipo U
				3'b110 : ImmExt[20:0] <= {ImmIn[24], ImmIn[12:5], ImmIn[13], ImmIn[23:14], 1'b0};			//Tipo J
		endcase
	end
endmodule 