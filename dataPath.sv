
module datapath(input  logic        clk, reset,
                output logic [31:0] Adr, WriteData,
                input  logic [31:0] ReadData,
                output logic [31:0] Instr,
                output logic [3:0]  ALUFlags,
                input  logic        PCWrite, RegWrite,
                input  logic        IRWrite,
                input  logic        AdrSrc, 
                input  logic [1:0]  RegSrc, 
                input  logic [1:0]  ALUSrcA, ALUSrcB, ResultSrc,
                input  logic [1:0]  ImmSrc, ALUControl);

	logic [31:0] PCNext, PC;
	logic [31:0] ExtImm, SrcA, SrcB, Result;
	logic [31:0] Data, RD1, RD2, A, ALUResult, ALUOut;
	logic [3:0]  RA1, RA2;

	// Your datapath hardware goes below. Instantiate each of the 
	// submodules that you need. Remember that you can reuse hardware
    // from the book. Be sure to give your instantiated modules 
	// applicable names such as pcreg (PC register), adrmux 
	// (Address Mux), etc. so that your code is easier to understand.

	// ADD CODE HERE
	
	assign PC = Result;
	
	ProgramCounter Pc(clk, reset,
				      PCWrite,
				   	  PC,
					  PCNext);
					  
	mux2 AddressMux(PCNext,
					Result,
					AdrSrc,
					Adr);
					
	flopr DataReg(clk, reset, 
			      ReadData,
				  Data);
				 
	flopenr InsReg(clk,
					reset,
					IRWrite,
					ReadData,
					Instr);
	mux2#(4) RegSrc1(Instr[19:16],
					  4'hF,
					  RegSrc[0],
					  RA1);
					  
	mux2#(4) RegSrc2(Instr[3:0],
					  Instr[15:12],
					  RegSrc[1],
					  RA2);
	
	regfile RegisterFile(clk, reset, 
						 RegWrite,
						 RA1, RA2,
						 Instr[15:12],
						 Result,
						 Result,
						 RD1, RD2);
	
	extend ExtUnit(Instr[23:0],
				   ImmSrc,
				   ExtImm);
	
	flopr RegDataReg1(clk,
						reset,
						RD1,
						A);
						
	flopr RegDataReg2(clk,
						reset,
						RD2,
						WriteData);
						 
	mux2 ALUSrcAmux(A,
					PCNext,
					ALUSrcA[0],
					SrcA);
	
	//shihter
	logic [31:0] WriteData_sh;
   Shifter WriteDsh(WriteData,
					 Instr[11:7],
					 Instr[6:5],
					 WriteData_sh); 
	
	mux3#(32) ALUSrcBmux(WriteData_sh,
					ExtImm,
					32'd4,
					ALUSrcB,
					SrcB);
					
	ALU MultiCAlu(SrcA,
				  SrcB,
				  ALUControl,
				  ALUResult,
				  ALUFlags);
	
	flopr AluOutReg(clk,
					  reset,
					  ALUResult,
					  ALUOut);
					  
	mux3#(32) ResultMux(ALUOut,
						Data,
						ALUResult,
						ResultSrc,
						Result);		  

endmodule


// ADD CODE BELOW
// Add needed building blocks below (i.e., parameterizable muxes, 
// registers, etc.). Remember, you can reuse code from the book.
// We've also provided a parameterizable 3:1 mux below for your 
// convenience.

module Shifter #(parameter N = 32)(input logic [N-1:0] in,
								   input logic[4:0]Shamt,
								   input logic[1:0]Type,
								   output logic[N-1:0] out);
  always_comb
    case (Type)
      2'b00: out = in <<  Shamt; //LSL
      2'b01: out = in >>  Shamt; //LSR
      2'b10: out = in >>> Shamt; //ASR
      2'b11: out = (in >> Shamt) | (in << N - Shamt); //ROR
      default: out = in;
    endcase
endmodule

module ProgramCounter #(parameter	WIDTH	= 32)
									  (input logic	clk, reset,
									   input logic						en,
									   input logic[(WIDTH - 1):0]	AddrIn,
									   output logic[(WIDTH - 1):0]	AddrOut);


	always_ff	@(posedge clk, negedge ~reset)
	begin
		if (reset)				AddrOut <= 32'd0;
		else if (en)			AddrOut <= AddrIn;
	end

endmodule

module flopenr #(parameter WIDTH = 32)
				(input logic clk, reset, en,
				input logic [WIDTH-1:0] d,
				output logic [WIDTH-1:0] q);
				
	always_ff @(posedge clk, negedge ~reset)
		if (reset) q <= 0; 
		else if (en) q <= d; 
endmodule

module flopr #(parameter WIDTH = 32)
			  (input logic clk, reset,
			  input logic [WIDTH-1:0] d,
			  output logic [WIDTH-1:0] q);
			  
	always_ff @(posedge clk, negedge ~reset)
		if (reset) q <= 0;
		else q <= d;
endmodule

module extend(input logic [23:0] Instr,
			  input logic [1:0] ImmSrc,
			  output logic [31:0] ExtImm);
			  
	always_comb
		case(ImmSrc)
					// 8-bit unsigned immediate
			2'b00: ExtImm = {24'b0, Instr[7:0]};
					// 12-bit unsigned immediate
			2'b01: ExtImm = {20'b0, Instr[11:0]};
					// 24-bit two's complement shifted branch
			2'b10: ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
			default: ExtImm = 32'bx; // undefined 
	endcase 
endmodule

module regfile(input logic clk, reset,
			   input logic we3,
			   input logic [3:0] ra1, ra2, wa3,
			   input logic [31:0] wd3, r15,
			   output logic [31:0] rd1, rd2);
	logic [31:0] rf[15:0];
	// three ported register file 
	// read two ports combinationally
	// write third port on rising edge of clock
	// register 15 reads PC+8 instead
	always_ff @(posedge clk, negedge ~reset)
		if (reset)
		begin
			int i;
			for (i = 0; i < 16; i = i + 1)	rf[i] = 32'd0;
		end
		else if (we3) rf[wa3] <= wd3;
	assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1]; 
	assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2]; 
endmodule

module mux2 #(parameter	WIDTH	= 32)
					(input logic[(WIDTH - 1):0]	d0, d1,
					 input logic						s,
					 output logic[(WIDTH - 1):0]	y);

	assign y = s ?	d1 : d0;
endmodule

module ALU#(parameter WIDTH = 32) (input logic [31:0] a,b,
			input logic [31:0] ALUcontrol,
			output logic [31:0] Result ,
			output logic [3:0] ALUflags);
	logic neg,zero,carry,overflow;
	logic [31:0] condinvb;
	logic [32:0] sum;
	assign condinvb = ALUcontrol[0] ? ~b:b;
	assign sum = a + condinvb + ALUcontrol[0];
	always_comb 
		casex (ALUcontrol[1:0])
		2'b0?: Result = sum;
		2'b10: Result = a&b;
		2'b11: Result = a|b;
	endcase

	assign neg = Result[31];
	assign zero = (Result == 32'b0);
	assign carry = (ALUcontrol[1] == 1'b0) & sum[32];
	assign overflow = (ALUcontrol[1] == 1'b0) & ~(a[31]^b[31]^ALUcontrol[0]) 
					&(a[31]^sum[31]);
	assign ALUflags = {neg , zero , carry , overflow};
endmodule // ALU

module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

	assign y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

