import definitions::*;

module mips_single_cycle
	#(parameter INS_SIZE=32)
	 (input logic clk,
	  input logic[INS_SIZE-1:0] instruction,
	  input logic[31:0] dm_q,
	  output logic dm_we,
	  output logic [15:0] dm_address,
	  output logic [31:0] dm_d,
	  output logic [31:0] pc_out
	 );

opcode ins_op;
logic[4:0] ins_rs;
logic[4:0] ins_rt;
logic[4:0] ins_rd;
logic[4:0] ins_sa;
logic[5:0] ins_func;
logic[15:0] ins_imm;

operation alu_op;

logic rf_we;
logic sel_op_a;
logic sel_op_b;
logic zero_or_sign;
logic [1:0]rd_sel;
logic [1:0]rf_data_sel;
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

logic[31:0] next_pc;
logic[31:0] pc;
logic[2:0] pc_sel;
logic[25:0] ins_addr;

logic rs_sel;
logic [4:0]rs;

logic negative;

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
		 .bne(bne),
		 .pc_sel(pc_sel),
		 .rs_sel(rs_sel)
		 );

regfile regfile0
	 (.rs(rs),
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
	  .z(zero),
	  .n(negative)
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
	ins_op = opcode'(instruction[31:26]);
	ins_rs = instruction[25:21];
	ins_rt = instruction[20:16];
	ins_rd = instruction[15:11];
	ins_sa = instruction[10:6];
	ins_func = instruction[5:0];
	ins_imm = instruction[15:0];
	
	ins_addr = instruction[25:0];

	//muxes
	operandA = (sel_op_a) ? ext_sa : Qs;
	operandB = (sel_op_b) ? ext_imm : Qt;
	dm_address = (mem_ad_sel) ? ins_imm : Qs;
	rs = (rs_sel) ? 5'd31 : ins_rs; 
	
	dm_d = Qt;
	
	pc_out = pc;
	
	//larger muxes
	case(rd_sel)
		0:
		begin
			rd = ins_rd;
		end
		1:
		begin
			rd = ins_rt;
		end
		2:
		begin
			rd = 5'd31;
		end
		default:
		begin
			rd = ins_rd;
		end
	endcase
	
	
	case(rf_data_sel)
		0:
		begin
			D = result;
		end
		1:
		begin
			D = dm_q;
		end
		2:
		begin
			D = pc+1;
		end
		default:
		begin
			D =  result;
		end
	endcase 
	
	

	case(pc_sel)
		0:
		begin
			next_pc = pc +1;
		end
		1:
		begin
			if(beq)
			begin
				if(zero)
					next_pc = {16'b0,ins_imm};
				else
					next_pc = pc+1;
			end
			else
			begin
				if(bne)
				begin
					if(~(zero))
						next_pc = {16'b0,ins_imm};
					else
						next_pc = pc+1;
				end
				else
					next_pc = pc+1;
			end
		end
		2:
		begin
			next_pc = {6'b0,ins_addr};
		end
		3:
		begin
			next_pc = Qs;
		end
		4: //branch on negative
		begin
			if(negative)
				next_pc = {16'b0,ins_imm};
			else
				next_pc = pc+1;
		end
		default:
			next_pc = pc+1;
	endcase
	

		
end


always_ff@(posedge clk)
begin
	pc <= next_pc;
end


endmodule


