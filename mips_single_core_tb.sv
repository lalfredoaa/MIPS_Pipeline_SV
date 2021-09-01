import definitions::*;

module mips_single_core_tb;

logic clk;
logic[31:0] instruction;
logic [31:0]dm_q;
logic dm_we;
logic [15:0] dm_address;
logic [31:0] dm_d;
logic [31:0] pc_out;

mips_single_cycle dut_mips
	 (.clk(clk),
	  .instruction(instruction),
	  .dm_q(dm_q),
	  .dm_we(dm_we),
	  .dm_address(dm_address),
	  .dm_d(dm_d),
	  .pc_out(pc_out)
	 );

ram dut_ram
	   (.clk(clk),
	    .dm_we(dm_we),
	    .dm_address(dm_address),
	    .dm_d(dm_d),
	    .dm_q(dm_q)
	);

initial begin
	
	mips_single_core_tb.dut_mips.pc = 0;	
	mips_single_core_tb.dut_mips.regfile0.mem[0] = 0;

	//first we tested the J-types as they were the new instructions
	instruction={J,26'd18};
	#6ns
	instruction={JAL,26'd24};
	#10ns
	instruction={RET,26'd0};

	//then we tried the old instructions again
	/*mips_single_core_tb.dut_mips.pc = 0;	  
	mips_single_core_tb.dut_mips.regfile0.mem[0] = 0;
	mips_single_core_tb.dut_mips.regfile0.mem[1] = 5;
	mips_single_core_tb.dut_mips.regfile0.mem[2] = 3;
	mips_single_core_tb.dut_mips.regfile0.mem[4] = 7;
	mips_single_core_tb.dut_mips.regfile0.mem[5] = 7;

	mips_single_core_tb.dut_ram.mem[3] = 6;
	mips_single_core_tb.dut_ram.mem[4] = 8;
	negative = -3;*/

	//R-Type
	/*to usea a simple syntaxis, we use the ALU codes as func, but add the 2'b first
	  because alu_op are 4 bits but the func is 6 bits*/
	/*instruction={RTYPE,5'd1,5'd2,5'd3,5'd0,2'b0,ALU_ADD};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd0,2'b0,ALU_SUB};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd0,2'b0,ALU_AND};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd0,2'b0,ALU_OR};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd0,2'b0,ALU_XOR};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd2,2'b0,ALU_SLL};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd2,2'b0,ALU_SRL};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd2,2'b0,ALU_SLA};
	instruction={RTYPE,5'd1,5'd2,5'd3,5'd2,2'b0,ALU_SRA};*/

	//I-Type
	//instruction={ADDI,5'd1,5'd3,negative};
	//instruction={SUBI,5'd1,5'd3,negative};
	//instruction={ANDI,5'd1,5'd3,16'd4};
	//instruction={ORI,5'd1,5'd3,16'd4};
	//instruction={XORI,5'd1,5'd3,16'd4};
	//instruction={LUI,5'd1,5'd3,16'd15};
	//instruction={LLI,5'd1,5'd3,16'd4};
	//instruction={LWR,5'd2,5'd3,16'd4};
	//instruction={SWR,5'd1,5'd2,16'd4};
	//instruction={LWI,5'd1,5'd3,16'd4};
	//instruction={SWI,5'd1,5'd2,16'd6};
	//instruction={BEQ,5'd4,5'd5,16'd15};
	//instruction={BNE,5'd4,5'd5,16'd15};


	
end

always begin
	clk = 0;
	#5ns;
	clk = 1;
	#5ns;
end

endmodule
