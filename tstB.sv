module tstB();
	logic					s_CLK, s_NRESET;
	logic[31:0]	s_Write_Data, s_Address;
	logic					s_MemWrite;


	top		DUT
		(s_CLK, s_NRESET,
		s_Write_Data,
		s_Address,
		s_MemWrite);

	initial
	begin
		s_CLK		= 1'b0;
		s_NRESET	= 1'b0;
	end

	always
	begin
		#5;	s_CLK = ~s_CLK;
	end


	event ResetTrigger_Event;
		event ResetTriggerDone_Event;
		initial
		forever
		begin
			@(ResetTrigger_Event);
			@(negedge s_CLK);
			s_NRESET = 1'b1;
			repeat (2)	@(negedge s_CLK);
			s_NRESET = 1'b0;
			->	ResetTriggerDone_Event;
		end

	event FinishTestbench_Event;
	initial
	begin
		@(FinishTestbench_Event);
		#47;	$stop;
	end

	event Testbench_Event;
		event TestbenchDone_Event;
		initial
		forever
		begin
			@(Testbench_Event);
			#27;
			if (s_MemWrite)
			begin
				if (s_Address == 100)
				begin
					if (s_Write_Data === 7)
					begin
						$display("Simulation succeeded!");
						repeat (2)	@(negedge s_CLK);
						$stop;
					end
					else
					begin
						$warning("Simulation failed");
						repeat (2)	@(negedge s_CLK);
						$stop;
					end
				end
			end
			//repeat (2)	@(negedge s_CLK);
			#850;
			->	TestbenchDone_Event;
			->	FinishTestbench_Event;
		end

	event SystemInitialization_Event;
		event SystemInitializationDone_Event;
		initial
		begin
			@(ResetTriggerDone_Event);
			#1;	->	Testbench_Event;
		end


	initial
	begin
		#17;	->	ResetTrigger_Event;
	end


endmodule