module PC_En(In, Out, Clk, En);
  input logic [31:0] In;
  input logic Clk;
  output logic [31:0] Out;
  input logic En;
  
  initial begin
    Out = 32'b0;
  end
  always_ff @ (posedge Clk)begin
    if (En == 0)begin
      Out <= In;
    end
  end
endmodule
