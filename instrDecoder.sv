module instrDecoder (	input	logic [1:0] Op,
						output	logic [1:0] ImmSrc, RegSrc);
	
	assign RegSrc = (Op == 00) ? 2'b00 : (Op == 01) ? 2'b 10 : 2'b01 ; 
	assign ImmSrc = (Op == 00) ? 2'b00 : (Op == 01) ? 2'b 01 : 2'b10 ;
endmodule