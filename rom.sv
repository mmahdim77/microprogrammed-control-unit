module rom(input logic [4:0] adr,
output logic [19:0] dout);
    always_comb
        case(adr)
			
			//Aluop_B_NextPc_RegW_MemW_IrWrite_AdrSrc_ResultSrc[2]_AluSrcA[2]_AluSrcB[2]_AluControl[2]_NextAdr[5]	
				5'b00000: dout = 20'b00100101001100000001; //Fetch
            5'b00001: dout = 20'b00000001001100011111; //Decode
            5'b00010: dout = 20'b00000000000010011110; //MemAdr
            5'b00011: dout = 20'b00000010000000000100; //memread
            5'b00100: dout = 20'b00010000100000000000; //memwb
            5'b00101: dout = 20'b00001010000000000000; //memwrite
            5'b01000: dout = 20'b00010000000000000000; //AluWb
            5'b01001: dout = 20'b01000001000010000000; //Branch
			
			//execute R
			5'b00110: dout = 20'b10000000000000001000; //ERADD
			5'b01010: dout = 20'b10000000000000101000; //ERSUB
			5'b01011: dout = 20'b10000000000001001000; //ERAND
			5'b01100: dout = 20'b10000000000001101000; //EROR
			
			//execute I
			5'b00111: dout = 20'b10000000000010001000; //EIADD
			5'b01101: dout = 20'b10000000000010101000; //EISUB
			5'b01110: dout = 20'b10000000000011001000; //EIAND
			5'b01111: dout = 20'b10000000000011101000; //EIOR
			
			default : dout = 20'b00000000000000000001; // undefined
			


        endcase
endmodule
