module itype
	#(parameter INS_SIZE=32)
	 (input logic clk,
	  input logic[INS_SIZE-1:0] instruction,
	  input logic[31:0] dm_q,
	  input logic[15:0] pc,
	  output logic dm_we,
	  output logic [15:0] dm_address,
	  output logic [31:0] dm_d,
	  output logic [15:0] next_pc
	 );

logic[5:0] ins_op;
logic[4:0] ins_rs;
logic[4:0] ins_rt;
logic[4:0] ins_rd;
logic[4:0] ins_sa;
logic[5:0] ins_func;
logic[15:0] ins_imm;

logic [3:0] alu_op;

logic rf_we;
logic sel_op_a;
logic sel_op_b;
logic zero_or_sign;
logic rd_sel;
logic rf_data_sel;
logic mem_ad_sel;

logic[31:0] operandA;
logic[31:0] operandB;
logic[31:0] result;
logic zero;

logic[31:0] ext_sa;
logic[31:0] ext_imm;

logic[31:0] Qs;
logic[31:0] Qt;
logic[31:0] D;
logic[4:0] rd;

logic beq;
logic bne;

controller controller0
		(.op(ins_op),
		 .func(ins_func),
		 .rf_we(rf_we),
		 .sel_op_a(sel_op_a),
		 .sel_op_b(sel_op_b),
		 .zero_or_sign(zero_or_sign),
		 .rd_sel(rd_sel),
		 .rf_data_sel(rf_data_sel),
		 .mem_ad_sel(mem_ad_sel),
		 .dm_we(dm_we),
		 .beq(beq),
		 .bne(bne)
		 );

regfile regfile0
	 (.rs(ins_rs),
	  .rt(ins_rt),
	  .rd(rd),
	  .D(D),
	  .we(rf_we),
	  .clk(clk),
	  .Qs(Qs),
	  .Qt(Qt)
	 );

alu alu0
	 (.a(operandA),
	  .b(operandB),
	  .op(alu_op),
	  .r(result),
	  .z(zero)
	);

extender extender0
	(.sa(ins_sa),
	 .imm(ins_imm),
	 .zero_or_sign(zero_or_sign),
	 .ext_sa(ext_sa),
	 .ext_imm(ext_imm) 
	);

instruction_decoder instruction_decoder0
	 (.op(ins_op),
	  .func(ins_func),
	  .alu_op(alu_op)
	 );

always_comb
begin
	//dividing instruction
	ins_op = instruction[31:26];
	ins_rs = instruction[25:21];
	ins_rt = instruction[20:16];
	ins_rd = instruction[15:11];
	ins_sa = instruction[10:6];
	ins_func = instruction[5:0];
	ins_imm = instruction[15:0];
	
	//muxes
	operandA = (sel_op_a) ? ext_sa : Qs;
	operandB = (sel_op_b) ? ext_imm : Qt;
	rd = (rd_sel) ? ins_rt : ins_rd;
	D = (rf_data_sel) ? dm_q : result;
	dm_address = (mem_ad_sel) ? ins_imm : Qs;
	
	dm_d = Qt;
	
	
	if(beq)
	begin
		if(zero)
			next_pc = ins_imm;
		else
			next_pc = pc;
	end
	else
	begin
		if(bne)
		begin
			if(~(zero))
				next_pc = ins_imm;
			else
				next_pc = pc;
		end
		else
			next_pc = pc;
	end
		
	//this way of coding gave us some problems
	/*if(beq && zero)
		begin	
		
		end
	else
		begin	
		
		end 
	
	if(bne && ~(zero))
		begin
		next_pc = ins_imm;
		end
	else
		begin
		next_pc = pc;
		end*/
end


endmodule

