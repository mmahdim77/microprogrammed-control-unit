module AluDecoder (	input	logic AluOp,
					input	logic [4:0] Funct,
					output	logic [1:0] FlagW,
					output logic noRegW);
					
	logic [1:0] flagWDetection;
	
	assign FlagW = (AluOp) ? flagWDetection : 2'b00 ;
	assign flagWDetection = (Funct[4:1] == 4'b0100  | Funct[4:1] == 4'b1010 ) ? 2'b11 : (Funct[4:1] == 4'b0010 ) ? 2'b11 : (Funct[4:1] == 4'b0000 ) ? 2'b10 : 2'b10 ;
	assign noRegW = (Funct[4:1] == 4'b1010);
endmodule

