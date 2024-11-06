module Data_memory(Address, DataWr, DMWr, DMCtrl, DataRd);
  input logic [31:0] Address;
  input logic [31:0] DataWr;
  input logic DMWr;
  input logic [2:0] DMCtrl;
  output logic [31:0] DataRd;
  logic [7:0] Memory [0:31];
  
  initial begin
    for (int i = 0; i <= 31; i++) begin
      Memory[i] = 8'b0;
    end
  end
  always @(DMCtrl || Address) begin
    DataRd = 32'b0;
    case(DMCtrl)
      3'b000: DataRd[31:0] = {{24{Memory[Address][7]}}, Memory[Address]};   										// lb: load byte
      3'b001: DataRd[31:0] = {{16{Memory[Address + 1][7]}}, Memory[Address + 1], Memory[Address]}; 					// lh: load halfword
      3'b010: DataRd[31:0] = {Memory[Address + 3], Memory[Address + 2], Memory[Address + 1], Memory[Address]}; 	// lw: load word
      3'b100: DataRd[31:0] = {24'b0, Memory[Address]};       														// lb (U): load byte unsigned
      3'b101: DataRd[31:0] = {16'b0, Memory[Address + 1], Memory[Address]};               						// lh (U): load halfword unsigned
      default: DataRd = 32'b0;        
    endcase
  end

  always @(*) begin
    if (DMWr)begin 
      case(DMCtrl)
        3'b000: Memory[Address] <= DataWr[7:0];       // sb: save byte
        3'b001: begin 
          Memory[Address] <= DataWr[7:0];       		// sh: save halfword
          Memory[Address + 1] <= DataWr[15:8];
        end
        3'b010: begin
          Memory[Address] <= DataWr[7:0];       
          Memory[Address + 1] <= DataWr[15:8];
          Memory[Address + 2] <= DataWr[23:16];		// sw: save word
          Memory[Address + 3] <= DataWr[31:24];
        end
        default: ;
      endcase
    end
  end
endmodule
