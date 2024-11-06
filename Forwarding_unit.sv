module Forwarding_unit (rs1_ex, rs2_ex, rd_me, rd_wb, RUWr_me, RUWr_wb, FUBSrc, FUASrc);
  input logic [4:0] rs1_ex;
  input logic [4:0] rs2_ex;
  input logic [4:0] rd_me;
  input logic [4:0] rd_wb;
  input logic RUWr_me;
  input logic RUWr_wb;
  output logic [1:0] FUBSrc;
  output logic [1:0] FUASrc;
  
  always @(*) begin
      FUASrc = 2'b00;
      FUBSrc = 2'b00;
      if(RUWr_me)begin
        if (rd_me == rs1_ex || rd_me == rs2_ex) begin
          FUASrc <= 2'b10;
          FUBSrc <= 2'b10;
        end
      end
      if (RUWr_wb)begin
        if (rd_wb == rs1_ex || rd_wb == rs2_ex) begin
          FUASrc <= 2'b11;
          FUBSrc <= 2'b11;
        end
      end
    end
endmodule