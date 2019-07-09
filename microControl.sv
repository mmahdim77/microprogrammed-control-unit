module micro_control (input logic  clk, reset,
					  input logic [5:0]Funct,
					  input logic [1:0] Op,
					  output logic RegW, MemW, IRWrite, NextPC,
					  output logic AdrSrc,B,
					  output logic [1:0] ResultSrc,
					  output logic [1:0] SrcA,SrcB,ALUControl,
					  output logic ALUOp);

	logic[4:0] branch_target;
  	logic[4:0] curr_address;
 	logic[19:0] control_line;
 	logic[19:0] next_add_control;
	
	always_ff @(posedge clk, posedge reset) 
    	if (reset)  
			begin
				curr_address<= 5'b00000;
			end
		
    	else curr_address <= branch_target ;

    sequenceLogic seq_logic (control_line[4:0],Op,Funct,branch_target);

    rom memory (curr_address , control_line);
    flopr cont_buffer_reg (clk , reset , control_line , next_add_control);
	
	assign {ALUOp,B,NextPC,RegW,MemW,IRWrite,AdrSrc,ResultSrc} = control_line[19:11];
	assign SrcA = control_line[10:9];
	assign SrcB = control_line[8:7];
	assign ALUControl = control_line[6:5];
	

endmodule