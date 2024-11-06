module ControlUnit_me(RUWr, DMWr, DMCtrl, RUDataWrSrc, Clk, RUWr_out, DMWr_out, DMCtrl_out, RUDataWrSrc_out);
  input logic [2:0] DMCtrl;
  input logic [1:0] RUDataWrSrc;
  input logic RUWr;
  input logic DMWr;
  input logic Clk;
  output logic [2:0] DMCtrl_out;
  output logic [1:0] RUDataWrSrc_out;
  output logic RUWr_out;
  output logic DMWr_out;
  
  always_ff @ (posedge Clk) begin
    DMCtrl_out <= DMCtrl;
    RUDataWrSrc_out <= RUDataWrSrc;
    RUWr_out <= RUWr;
    DMWr_out <= DMWr;
  end
endmodule