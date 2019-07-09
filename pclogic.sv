module PCLogic (input	logic [3:0] Rd,
				input	logic Branch,RegW,
				output	logic pcs);
	logic checkBranch, checkRegW;
	assign pcs = (Rd == 4'b1111) ? checkRegW : checkBranch ;
	assign checkBranch	= (Branch) ? 1'b1 : 1'b0;
	assign checkRegW	= (RegW) ? 1'b1 : 1'b0;
endmodule

