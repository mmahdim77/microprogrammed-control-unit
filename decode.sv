module decode(input  logic       clk, reset,
              input  logic [1:0] Op,
              input  logic [5:0] Funct,
              input  logic [3:0] Rd,
              output logic [1:0] FlagW,
              output logic       PCS, NextPC, RegW, MemW,
              output logic       IRWrite, AdrSrc, noRegW,
              output logic [1:0] ResultSrc, ALUSrcA, ALUSrcB, 
              output logic [1:0] ImmSrc, RegSrc, ALUControl);

  // ADD CODE HERE
  // Implement a microprogrammed controller
  // using a control memory (ROM).
  
	logic Branch;
	  
	micro_control mc(clk,reset,
					   Funct,
					   Op,
					   RegW, MemW, IRWrite, NextPC,
					   AdrSrc, Branch,
					   ResultSrc,
					   ALUSrcA,ALUSrcB,ALUControl,
					   ALUOp);
					  
	PCLogic pl(Rd,
			   Branch, RegW,
			   PCS);
				 
	AluDecoder aludec(ALUOp,
						Funct[4:0],
						FlagW,
						noRegW);
	
	instrDecoder insdec(Op ,
						ImmSrc, RegSrc);
						
endmodule