module Procesador_monociclo_segmentado(Clk);
  input logic Clk;
  logic [31:0]Out_PC_fe;
  logic HUDStall;
  logic [31:0]Out_PCInc_de;
  logic [31:0]Out_PC_de;
  logic [31:0]Out_Instruction;
  logic [31:0]Out_Inst_de;
  logic [31:0]Out_PCInc_ex;
  logic [31:0]Out_PC_ex;
  logic [31:0]Out_RUrs1_ex;
  logic [31:0]Out_RUrs2_ex;
  logic [31:0]Out_ImmExt_ex;				//BUSES DE DATOS
  logic [4:0]Out_rd_ex;
  logic [4:0]Out_rs1_ex;
  logic [4:0]Out_rs2_ex;
  logic [31:0]Out_PCInc_me;
  logic [31:0]Out_ALURes_me;
  logic [31:0]Out_RUrs2_me;
  logic [4:0]Out_rd_me;
  logic [31:0]Out_PCInc_wb;
  logic [31:0]Out_DMDataRd_wb;
  logic [31:0]Out_ALURes_wb;
  logic [4:0]Out_rd_wb;
  logic [1:0]FUASrc;
  logic [1:0]FUBSrc;
  logic RUWr_de;
  logic [2:0]ImmSrc_de;
  logic ALUASrc_de;
  logic ALUBSrc_de;
  logic [4:0]BrOp_de;
  logic [3:0]ALUOp_de;
  logic DMWr_de;
  logic [2:0]DMCtrl_de;
  logic [1:0]RUDataWrSrc_de;
  logic DMRd_de;
  logic RUWr_ex;
  logic ALUASrc_ex;
  logic ALUBSrc_ex;
  logic [4:0]BrOp_ex;
  logic [3:0]ALUOp_ex;
  logic DMWr_ex;
  logic [2:0]DMCtrl_ex;
  logic [1:0]RUDataWrSrc_ex;
  logic DMRd_ex;
  logic [2:0]DMCtrl_me;
  logic [1:0]RUDataWrSrc_me;
  logic RUWr_me;
  logic DMWr_me;
  logic [1:0]RUDataWrSrc_wb;
  logic RUWr_wb;
  logic [31:0]rs1;
  logic [31:0]rs2;
  logic NextPCSrc;
  logic [31:0]ImmExt;
  logic [31:0]MuxA_ex;
  logic [31:0]MuxB_ex;
  logic [31:0]MuxA;
  logic [31:0]MuxB;
  logic [31:0]Alu_out;
  logic [31:0]DataRd;
  logic [31:0]MuxRUDataWrSrc;
  logic [31:0]Suma;
  logic [31:0]MuxSalto;

  always @* begin
    Suma <= Out_PC_fe + 4;							//SUMADOR
    if(ALUASrc_ex)
      MuxA = Out_PC_ex;
    else        								//MULTIPLEXOR DE LA ENTRADA DEL ALU (A)
      MuxA = MuxA_ex;

    if(ALUBSrc_ex)begin
      MuxB = Out_ImmExt_ex;
    end else begin								//MULTIPLEXOR DE LA ENTRADA DEL ALU (B)
      MuxB = MuxB_ex;
    end

    case(RUDataWrSrc_wb)
      2'b10 : MuxRUDataWrSrc = Out_PCInc_wb;
      2'b01 : MuxRUDataWrSrc = Out_DMDataRd_wb;			//MULTIPLEXOR RUDATAWRSRC
      2'b00 : MuxRUDataWrSrc = Out_ALURes_wb;
      default : MuxRUDataWrSrc = 2'b00;
    endcase

    if(NextPCSrc)begin
      MuxSalto <= Alu_out;
    end else begin								//MULTIPLEXOR DE SALTO	
      MuxSalto <= Suma;
    end
    
    case(FUASrc)
      2'b11 : MuxA_ex = MuxRUDataWrSrc;
      2'b10 : MuxA_ex = Out_ALURes_me;						//MUXA_EX
      2'b00 : MuxA_ex = Out_RUrs1_ex;
      default : MuxA_ex = 2'b00;
    endcase
    
    case(FUBSrc)
      2'b11 : MuxB_ex = MuxRUDataWrSrc;
      2'b10 : MuxB_ex = Out_ALURes_me;						//MUXB_EX
      2'b00 : MuxB_ex = Out_RUrs2_ex;
      default : MuxB_ex = 2'b00;
    endcase
  end   
  
  Instruction_memory im(
    .Address(Out_PC_fe),										//INSTANCIA DEL INSTRUCTION MEMORY
    .Instruction(Out_Instruction)
  );     
  
  PC_En PC_fe(
    .In(MuxSalto),
    .Out(Out_PC_fe),										//PC_Fe
    .Clk(Clk),
    .En(HUDStall)
  );
  
  PC_En PCInc_de(
    .In(Suma),
    .Out(Out_PCInc_de),										//PCInc_de
    .Clk(Clk),
    .En(HUDStall)
  );
  
  PC_En PC_de(
    .In(Out_PC_fe),
    .Out(Out_PC_de),										//PC_de
    .Clk(Clk),
    .En(HUDStall)
  );
  
  Instruction_de Inst_de(
    .In(Out_Instruction),
    .Clear(NextPCSrc),										//Inst_de
    .Clk(Clk),
    .Out(Out_Inst_de),
    .En(HUDStall)
  );
  
  Control_unit cu(
    .OpCode(Out_Inst_de[6:0]),
    .Funct3(Out_Inst_de[14:12]),
    .Funct7(Out_Inst_de[31:25]),
    .RUWr(RUWr_de),
    .ImmSrc(ImmSrc_de),
    .AluASrc(ALUASrc_de),
    .AluBSrc(ALUBSrc_de),										//INSTANCIA DEL CONTROL UNIT
    .BrOp(BrOp_de),
    .ALUOp(ALUOp_de),
    .DMWr(DMWr_de),
    .DMCtrl(DMCtrl_de),
    .DMRd(DMRd_de),
    .RUDataWrSrc(RUDataWrSrc_de)
  );
  
  Hazard_detection_unit HDU(
    .rs1_de(Out_Inst_de[19:15]),
    .rs2_de(Out_Inst_de[24:20]),
    .rd_ex(Out_Inst_de[11:7]),								//Hazard_detection_unit
    .DMRd_ex(DMRd_ex),
    .HDUStall(HUDStall)
  );
  
  Register_unit ru(
    .Clk(Clk),
    .RuDataWr(MuxRUDataWrSrc),
    .Rs1(Out_Inst_de[19:15]),
    .Rs2(Out_Inst_de[24:20]),								//INSTANCIA DEL REGISTER UNIT
    .Rd(Out_rd_wb),
    .RuWr(RUWr_wb),
    .RuRs1(rs1),
    .RuRs2(rs2)
  );
  
  Imm_unit iu(
    .ImmIn(Out_Inst_de[31:7]),
    .ImmSrc(ImmSrc_de),										//INSTANCIA DEL IMMEDIATE GENERATOR
    .ImmExt(ImmExt)
  );
  
  ControlUnit_ex CU_ex(
    .BrOp(BrOp_de),
    .DMCtrl(DMCtrl_de),
    .ALUOp(ALUOp_de),
    .RUDataWrSrc(RUDataWrSrc_de),
    .ALUASrc(ALUASrc_de),
    .ALUBSrc(ALUBSrc_de),
    .RUWr(RUWr_de),
    .DMWr(DMWr_de),
    .DMRd(DMRd_de),
    .Clk(Clk),
    .BrOp_out(BrOp_ex),
    .DMCtrl_out(DMCtrl_ex),									//ControlUnit_ex
    .ALUOp_out(ALUOp_ex),
    .RUDataWrSrc_out(RUDataWrSrc_ex),
    .ALUASrc_out(ALUASrc_ex),
    .ALUBSrc_out(ALUBSrc_ex),
    .RUWr_out(RUWr_ex),
    .DMWr_out(DMWr_ex),
    .DMRd_out(DMRd_ex),
    .Clear(HUDStall),
    .ClearNext(NextPCSrc)
  );
  
  Registro32bits PCInc_ex(
    .In(Out_PCInc_de),
    .Clk(Clk),												//PCInc_ex
    .Out(Out_PCInc_ex)
  );
  
  Registro32bits PC_ex(
    .In(Out_PC_de),
    .Clk(Clk),												//PC_ex
    .Out(Out_PC_ex)
  );
  
  Registro32bits RUrs1_ex(
    .In(rs1),
    .Clk(Clk),												//RUrs1_ex
    .Out(Out_RUrs1_ex)
  );
  
  Registro32bits RUrs2_ex(
    .In(rs2),
    .Clk(Clk),												//RUrs2_ex
    .Out(Out_RUrs2_ex)
  );
  
  Registro32bits ImmExt_ex(
    .In(ImmExt),
    .Clk(Clk),												//ImmExt_ex
    .Out(Out_ImmExt_ex)
  );
  
  Registro5bits rd_ex(
    .In(Out_Inst_de[11:7]),
    .Clk(Clk),												//rd_ex
    .Out(Out_rd_ex)
  );
  
  Registro5bits rs1_ex(
    .In(Out_Inst_de[19:15]),
    .Clk(Clk),												//rs1_ex
    .Out(Out_rs1_ex)	
  );
  
  Registro5bits rs2_ex(
    .In(Out_Inst_de[24:20]),
    .Clk(Clk),												//rs2_ex
    .Out(Out_rs2_ex)
  );
  
  Forwarding_unit FU(
    .rs1_ex(Out_rs1_ex),
    .rs2_ex(Out_rs2_ex),
    .rd_me(Out_rd_me),
    .rd_wb(Out_rd_wb),												//Forwarding_unit
    .RUWr_me(RUWr_me),
    .RUWr_wb(RUWr_wb),
    .FUBSrc(FUBSrc),
    .FUASrc(FUASrc)
  );

  ALU alu(
    .A(MuxA),
    .B(MuxB),												//INSTANCIA DEL ALU
    .ALUOp(ALUOp_ex),
    .Alu_out(Alu_out)
  );                         

  Branch_unit bu(
    .In1(MuxB_ex),
    .In2(MuxA_ex),												//INSTANCIA DEL BRANCH UNIT
    .BrOp(BrOp_ex),
    .NextPCSrc(NextPCSrc)
  );
  
  ControlUnit_me CU_me(
    .DMCtrl(DMCtrl_ex),
    .RUDataWrSrc(RUDataWrSrc_ex),
    .RUWr(RUWr_ex),
    .DMWr(DMWr_ex),
    .Clk(Clk),												//ControlUnit_me
    .DMCtrl_out(DMCtrl_me),
    .RUDataWrSrc_out(RUDataWrSrc_me),
    .RUWr_out(RUWr_me),
    .DMWr_out(DMWr_me)
  );
  
  Registro32bits PCInc_me(
    .In(Out_PCInc_ex),
    .Clk(Clk),												//PCInc_me
    .Out(Out_PCInc_me)
  );
  
  Registro32bits ALURes_me(
    .In(Alu_out),
    .Clk(Clk),												//ALURes_me
    .Out(Out_ALURes_me)
  );
  
  Registro32bits RUrs2_me(
    .In(Out_RUrs2_ex),
    .Clk(Clk),												//RUrs2_me
    .Out(Out_RUrs2_me)
  );

  Registro5bits rd_me(
    .In(Out_rd_ex),
    .Clk(Clk),												//rd_me
    .Out(Out_rd_me)
  );
  
  Data_memory dm(
    .Address(Out_ALURes_me),
    .DataWr(Out_RUrs2_me),
    .DMWr(DMWr_me),											//INSTANCIA DEL DATA MEMORY
    .DMCtrl(DMCtrl_me),
    .DataRd(DataRd)
  );
  
  ControlUnit_wb CU_wb(
    .RUDataWrSrc(RUDataWrSrc_me),
    .RUWr(RUWr_me),											//ControlUnit_wb
    .Clk(Clk),
    .RUDataWrSrc_out(RUDataWrSrc_wb),
    .RUWr_out(RUWr_wb)
  );
  
   Registro32bits PCInc_wb(
    .In(Out_PCInc_me),
    .Clk(Clk),												//PCInc_wb
     .Out(Out_PCInc_wb)
  );
  
  Registro32bits DMDataRd_wb(
    .In(DataRd),
    .Clk(Clk),												//DMDataRd_wb
    .Out(Out_DMDataRd_wb)
  );
  
  Registro32bits ALURes_wb(
    .In(Out_ALURes_me),
    .Clk(Clk),												//ALURes_wb
    .Out(Out_ALURes_wb)
  );
  
  Registro5bits rd_wb(
    .In(Out_rd_me),
    .Clk(Clk),												//rd_wb
    .Out(Out_rd_wb)
  );

endmodule
		