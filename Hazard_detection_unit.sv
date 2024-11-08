module Hazard_detection_unit (rs1_de, rs2_de, rd_ex, HDUStall, DMRd_ex);
  
  input logic [4:0] rs1_de;
  input logic [4:0] rs2_de;
  input logic [4:0] rd_ex;
  input logic DMRd_ex;
  output logic HDUStall;
  
  initial begin
    HDUStall = 0;
  end
  always_comb begin
  HDUStall = 0;
    if (DMRd_ex) begin
      if (rs1_de == rd_ex || rs2_de == rd_ex) begin
        HDUStall = 1'b1;
      end else begin
		HDUStall = 0;
      end
    end
	end
endmodule