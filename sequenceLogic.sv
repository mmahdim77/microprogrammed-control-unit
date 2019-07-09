module sequenceLogic    (input  logic  [4:0]  tempNextAdr,
                         input  logic  [1:0]  op,
						 input	logic [5:0] Funct,
                         output logic  [4:0]  realNextAdr
                        );

    logic [4:0] temp10,temp11, tempEI,tempER;
	
	
    assign realNextAdr = (tempNextAdr == 5'b11111) ? temp10 : ((tempNextAdr==5'b11110) ? temp11 : tempNextAdr); 
    assign temp10 = (op==2'b01) ? 5'b00010 : (op==2'b10) ? 5'b01001 : (Funct[5]) ? tempEI : tempER;
    assign temp11 = (Funct[0]) ? 5'b00011: 5'b00101;
	assign tempEI = (Funct[4:1] == 4'b0100 ) ? 5'b00111 : (Funct[4:1] == 4'b0010 | Funct[4:1] == 4'b1010  ) ? 5'b01101 : (Funct[4:1] == 4'b0000 ) ? 5'b01110 : 5'b01111 ;
	assign tempER = (Funct[4:1] == 4'b0100 ) ? 5'b00110 : (Funct[4:1] == 4'b0010 | Funct[4:1] == 4'b1010  ) ? 5'b01010 : (Funct[4:1] == 4'b0000 ) ? 5'b01011 : 5'b01100 ;


endmodule
