module Register_unit(Rs1, Rs2, Clk, Rd, RuWr, RuDataWr, RuRs1, RuRs2);

  logic [31:0]Registers[0:31]; //Registros
  input logic Clk;  //Señal de Reloj
  input logic [31:0] RuDataWr; //Valor que se va a escribir en el registro
  input logic [4:0] Rs1; //Selecciona un registro para leerlo
  input logic [4:0] Rs2; //Selecciona un registro para leerlo
  input logic [4:0] Rd; //Elige el registro que se va a modificar
  input logic RuWr; //Habilitador de escritura
  output logic [31:0] RuRs1; //Salida del Register_unit
  output logic [31:0] RuRs2; //Salida del Register_unit
  
  initial begin
    for (int i = 0; i <= 31; i++) begin
        Registers[i] = 32'b0;
    end
  end
  always_ff @ (posedge Clk) //Lee el flanco de subida
    begin
      if (RuWr && (Rd != 0))begin //Activa la escritura cuando esta activo
        Registers[Rd] <= RuDataWr;  //Decodificador en el cual va activar el enable que se deseea
      end
    end

  always_comb begin
    RuRs1 = Registers[Rs1];
    RuRs2 = Registers[Rs2];
  end

endmodule
