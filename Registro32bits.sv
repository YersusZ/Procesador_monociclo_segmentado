module Registro32bits(In, Out, Clk);
  input logic [31:0] In;
  input logic Clk;
  output logic [31:0] Out;
  
  always_ff @ (posedge Clk) begin
    Out <= In;
  end
endmodule