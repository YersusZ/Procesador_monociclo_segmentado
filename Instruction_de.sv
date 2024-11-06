module Instruction_de (In, Out, Clk, Clear, En);
  input logic [31:0] In;
  input logic Clear;
  input logic Clk;
  input logic En;
  output logic [31:0]Out;
  
  always_ff @(posedge Clk)begin
    if(Clear)begin
      Out = 32'b00000000000000000000000000010011;
    end
    if (En == 0)begin
    	Out <= In;
    end
  end
endmodule