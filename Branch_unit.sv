module Branch_unit(In1, In2, BrOp, NextPCSrc);
	input logic [31:0]In1;
	input logic [31:0]In2;
	input logic [4:0]BrOp;    		//Definiendo entradas y salidas
	output logic NextPCSrc;
	always @* begin
		NextPCSrc=0;					//Inicialización de la salida en 0
		if(BrOp[4]) begin
			NextPCSrc = 1;				//Activa cuando el bit mas significativo es 1
		end
		if(BrOp[4:3] == 01) begin  //Evalua las condiciones cuando los 2 bits mas significativos es 10
			case(BrOp[3:0])
				4'b1000 : NextPCSrc = In1 == In2;
				4'b1001 : NextPCSrc = In1 != In2;
				4'b1100 : NextPCSrc = In1 < In2;	
				4'b1101 : NextPCSrc = In1 >= In2;									// condiciones
				4'b1110 : NextPCSrc = $unsigned(In1) < $unsigned(In2);
				4'b1111 : NextPCSrc = $unsigned(In1) >= $unsigned(In2);
				default : NextPCSrc = 0;
			endcase
		end
      if(BrOp[4:3] == 2'b00)begin	//No realiza el salto cuando los 2 bits mas significativos son 00
			NextPCSrc = 0;				//Salida en 0
		end
	end
endmodule 