module ALU(A, B, ALUOp, Alu_out);
  input logic[31:0]A;
  input logic[31:0]B;				//ENTRADAS Y SALIDAS
  input logic[3:0]ALUOp;
  output logic[31:0]Alu_out;
  
  always_comb
    begin
      case(ALUOp)
        4'b0000 : Alu_out = A + B;
        4'b1000 : Alu_out = A - B;
        4'b0001 : Alu_out = A << B[4:0];
        4'b0010 : Alu_out = {31'b0, A < B}; 
        4'b0011 :  Alu_out = {31'b0, $unsigned(A) < $unsigned(B)};
        4'b0100 : Alu_out = A ^ B;							//OPERACIONES
        4'b0101 : Alu_out = A >> B[4:0];
        4'b1101 : Alu_out = A >>> B[4:0];
        4'b0110 : Alu_out = A | B;
        4'b0111 : Alu_out = A & B;
        default : Alu_out = 32'b0;
        endcase
    end
endmodule