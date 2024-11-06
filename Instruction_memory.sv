module Instruction_memory(Address, Instruction);
	input logic [31:0]Address;
	output logic [31:0]Instruction;
  	logic [7:0]Memory[255:0];

  always @(Address) begin
      $readmemb("Instruction_memory.txt", Memory, 0, 79);
      Instruction = {Memory[Address], Memory[Address+1] , Memory[Address+2], Memory[Address+3]};
    end
endmodule