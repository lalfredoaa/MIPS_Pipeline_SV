import definitions::*;

module mips_mult_tb;

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

rom dut_rom
	(.rom_address(pc_out),
	  .rom_out(instruction)
	);


initial begin
	//Needed initializations
	mips_mult_tb.dut_mips.pc = 0;
	mips_mult_tb.dut_mips.regfile0.mem[0] = 0;
	//Numbers to multiply
	mips_mult_tb.dut_ram.mem[0] = 6; //A
	mips_mult_tb.dut_ram.mem[1] = -7; //B
	mips_mult_tb.dut_ram.mem[2] = 0; //R
	

	//ROM code
	/*mips_mult_tb.dut_rom.mem[0] = {LWI,5'd0,5'd1,16'd0}; //A
	mips_mult_tb.dut_rom.mem[1] = {LWI,5'd0,5'd2,16'd1}; //B
	mips_mult_tb.dut_rom.mem[2] = {LWI,5'd0,5'd3,16'd2}; //R
	
	mips_mult_tb.dut_rom.mem[3] = {BNEG,5'd2,5'd0,16'd9}; //Branch if B negative
	
	//Multiplication algorithm
	mips_mult_tb.dut_rom.mem[4] = {RTYPE,5'd1,5'd3,5'd3,5'd0,2'b0,ALU_ADD};
	mips_mult_tb.dut_rom.mem[5] = {SUBI,5'd2,5'd2,16'd1};
	mips_mult_tb.dut_rom.mem[6] = {BNE,5'd0,5'd2,16'd3};
	mips_mult_tb.dut_rom.mem[7] = {SWI,5'd0,5'd3,16'd2};
	mips_mult_tb.dut_rom.mem[8] = {J,26'd14};
		
	//If B is negative and A positive, we need to switch signs for the algorithm to work 
	//(we need B positive and A negative to keep the sign). On the other side, if both are negative,
	//we need to change both signs to multiply them as positives. Either way, we change both signs.
	//Change B sign
	mips_mult_tb.dut_rom.mem[9] = {RTYPE,5'd2,5'd0,5'd2,5'd0,2'b0,ALU_NOT}; //NOT B
	mips_mult_tb.dut_rom.mem[10] = {ADDI,5'd2,5'd2,16'd1}; //NOT B + 1
	//Change B sign
	mips_mult_tb.dut_rom.mem[11] = {RTYPE,5'd1,5'd0,5'd1,5'd0,2'b0,ALU_NOT}; //NOT A
	mips_mult_tb.dut_rom.mem[12] = {ADDI,5'd1,5'd1,16'd1}; //NOT A + 1
	mips_mult_tb.dut_rom.mem[13] = {J,26'd4};

	//END
	mips_mult_tb.dut_rom.mem[14] = {J,26'd14};*/

	//ROM code in binary
	/*mips_mult_tb.dut_rom.mem[0] = 32'b00101000000000010000000000000000;
	mips_mult_tb.dut_rom.mem[1] = 32'b00101000000000100000000000000001;
	mips_mult_tb.dut_rom.mem[2] = 32'b00101000000000110000000000000010;
	mips_mult_tb.dut_rom.mem[3] = 32'b01000100010000000000000000001001;
	mips_mult_tb.dut_rom.mem[4] = 32'b00000000001000110001100000000000;
	mips_mult_tb.dut_rom.mem[5] = 32'b00001000010000100000000000000001;
	mips_mult_tb.dut_rom.mem[6] = 32'b00110100000000100000000000000011;
	mips_mult_tb.dut_rom.mem[7] = 32'b00101100000000110000000000000010;
	mips_mult_tb.dut_rom.mem[8] = 32'b00111000000000000000000000001110;
	mips_mult_tb.dut_rom.mem[9] = 32'b00000000010000000001000000001011;	
	mips_mult_tb.dut_rom.mem[10] = 32'b00000100010000100000000000000001;
	mips_mult_tb.dut_rom.mem[11] = 32'b00000000001000000000100000001011;
	mips_mult_tb.dut_rom.mem[12] = 32'b00000100001000010000000000000001;
	mips_mult_tb.dut_rom.mem[13] = 32'b00111000000000000000000000000100;
	mips_mult_tb.dut_rom.mem[14] = 32'b00111000000000000000000000001110;*/
	
	//ROM loaded from file
	$readmemb("mult_rom.dat", mips_mult_tb.dut_rom.mem);
end

always begin
	clk = 0;
	#5ns;
	clk = 1;
	#5ns;
end

endmodule
