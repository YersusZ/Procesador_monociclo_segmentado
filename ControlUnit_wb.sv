module ControlUnit_wb(RUWr, RUDataWrSrc, Clk, RUWr_out, RUDataWrSrc_out);
  input logic [1:0] RUDataWrSrc;
  input logic RUWr;
  input logic Clk;
  output logic [1:0] RUDataWrSrc_out;
  output logic RUWr_out;
  
  always_ff @ (posedge Clk) begin
    RUDataWrSrc_out <= RUDataWrSrc;
    RUWr_out <= RUWr;
  end
endmodule