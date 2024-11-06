module Registro5bits(In, Out, Clk);
  input logic [4:0] In;
  input logic Clk;
  output logic [4:0] Out;
  
  always_ff @ (posedge Clk) begin
    Out <= In;
  end
endmodule