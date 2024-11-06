module ControlUnit_ex(BrOp, ALUASrc, ALUBSrc, ALUOp, RUWr, DMWr, DMCtrl, RUDataWrSrc, DMRd, Clk, Clear, BrOp_out, ALUASrc_out, ALUBSrc_out, ALUOp_out, RUWr_out, DMWr_out, DMCtrl_out, RUDataWrSrc_out, DMRd_out, ClearNext);
  input logic [4:0] BrOp;
  input logic [2:0] DMCtrl;
  input logic [3:0] ALUOp;
  input logic [1:0] RUDataWrSrc;
  input logic ALUASrc;
  input logic ALUBSrc;
  input logic RUWr;
  input logic DMWr;
  input logic DMRd;
  input logic Clk;
  input logic Clear;
  input logic ClearNext;
  output logic [4:0] BrOp_out;
  output logic [2:0] DMCtrl_out;
  output logic [3:0] ALUOp_out;
  output logic [1:0] RUDataWrSrc_out;
  output logic ALUASrc_out;
  output logic ALUBSrc_out;
  output logic RUWr_out;
  output logic DMWr_out;
  output logic DMRd_out;
  
  always_ff @ (posedge Clk) begin
    if (Clear || ClearNext) begin
      BrOp_out <= 5'b0;
      DMCtrl_out <= 3'b0;
      ALUOp_out <= 4'b0;
      RUDataWrSrc_out <= 2'b0;
      ALUASrc_out <= 1'b0;
      ALUBSrc_out <= 1'b0; 
      RUWr_out <= 1'b0;
      DMWr_out <= 1'b0;
      DMRd_out <= 1'b0;
    end else begin
      BrOp_out <= BrOp;
      DMCtrl_out <= DMCtrl;
      ALUOp_out <= ALUOp;
      RUDataWrSrc_out <= RUDataWrSrc;
      ALUASrc_out <= ALUASrc;
      ALUBSrc_out <= ALUBSrc; 
      RUWr_out <= RUWr;
      DMWr_out <= DMWr;
      DMRd_out <= DMRd;
  	end
   end
endmodule