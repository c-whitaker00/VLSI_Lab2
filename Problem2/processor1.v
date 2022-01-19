`timescale 1ns/10ps
module processor(clk);
input clk;
reg [11:0] pc_current, branch;
wire[31:0] ir;
wire [11:0] pc_next, pc, pc1;
wire [11:0] j, i, w;
reg[31:0] instruction_memory[127:0];
reg[4:0] PSR;
reg[31:0] reg_file[16:0];
reg[31:0] mem[255:0];
reg [15:0] sum;
reg carry;
integer inti, intj, k, int;

    initial begin 
        pc_current <= 12'd0;
        for (k = 0; k < 17; k = k + 1) begin
            reg_file[k] <= 32'd0;
        end
        mem[0] = 32'b00000000000000000000000000000110;
        mem[1] = 32'b00000000000000000000000000000001;
        mem[2] = 32'b00000000000000000000000000000000;
        mem[3] = 32'b00000000000000000000000000000000;
        mem[4] = 32'b00000000000000000000000000000000;
        mem[5] = 32'b00000000000000000000000000000000;
        instruction_memory[0] = 32'b00011001000000000000000000000000; // lw
        instruction_memory[1] = 32'b10011001000000000000000000000000; //complement
        instruction_memory[2] = 32'b00011001000000000001000000000001; //lw
        instruction_memory[3] = 32'b01011001000000000001000000000000; // add
        instruction_memory[4] = 32'b00101001000000000000000000000001; // store
        $display("Initially...");
        $strobe("Mem0 = %p, Mem1 = %p, Mem2 = %p", mem[0], mem[1], mem[2]);
        $strobe("IR0 = %p, IR1 = %p, IR2 = %p, IR3 = %p, IR4 = %p", instruction_memory[0], instruction_memory[1], instruction_memory[2], instruction_memory[3], instruction_memory[4]);
        $strobe("Initial PC: %p", pc_current);
    end
    always @ (posedge clk)
    begin 
        pc_current <= pc_next;
        $strobe("Current PC: %p", pc_current);
    end    
    assign pc1 = pc_current + 12'd1;
    assign pc = pc_current;
    assign ir = instruction_memory[pc];
    assign j = ir[23:12];
    assign i = ir[11:0];
    assign w = ir[11:0];
    
    always @(ir, j, i, w) begin
        $display("current IR: %p", ir);
        $display("Main instruction: %p", ir[31:28]);
        $strobe("Reg0 = %p, Reg1 = %p, Reg2 = %p", reg_file[0], reg_file[1], reg_file[2]);
        $strobe("Mem0 = %p, Mem1 = %p, Mem2 = %p", mem[0], mem[1], mem[2]);
        $display("current i: %p", i);
        $display("current j: %p", j);
        int <= w;
    end

    always @ (posedge clk)
        begin
            case(ir[31:28])
                4'b0000: //NOP
                    #0;
                4'b0001: begin //load
                    reg_file[i] <= mem[j];
                    PSR[0] <= 1'b0;
                  end
                4'b0010: //store
                    mem[i] <= reg_file[j];
                4'b0011: begin //branch
                    case(ir[27:24])
                        4'b0000: // always
                            branch <= j;
                        4'b0001: begin // parity
                            if (PSR[1] == 1'b1)
                                branch <= j;
                            else 
                                branch <= pc_current + 12'd1;  
                              end                  
                        4'b0010: begin // even
                            if (PSR[2] == 1'b1)
                                branch <= j;
                            else 
                                branch <= pc_current + 12'd1;
                              end
                        4'b0011: begin // carry
                            if (PSR[0] == 1'b1)
                                branch <= j;
                            else 
                                branch <= pc_current + 12'd1;
                              end
                        4'b0100: begin // negative 
                            if (PSR[3] == 1'b1)
                                branch <= j;
                            else
                               branch <= pc_current + 12'd1;
                              end
                        4'b0101: begin // zero
                            if (PSR[4] == 1'b1)
                                branch <= i;
                            else
                                branch <= pc_current + 12'd1;
                              end
                        4'b0110: begin // no carry
                            if (PSR[0] == 1'b0)
                                branch <= j;
                            else
                                branch <= pc_current + 12'd1;
                              end
                        4'b0111: begin // positive
                            if (PSR[3] == 1'b0)
                                branch <= j;
                            else
                                branch <= pc_current + 12'd1;
                              end
                        endcase
                      end

                4'b0100: // xor
                    reg_file[i] <= reg_file[j] ^ reg_file[i];
                4'b0101: begin//add  
                    {carry, sum} <= reg_file[j] + reg_file[i];
                    reg_file[i] <= reg_file[j] + reg_file[i];
                    if (sum[0] == 1'b0)
                        PSR[2] <= 1'b1;
                    else if (carry == 1'b1)
                        PSR[0] <= 1'b1;
                    else if (sum[0] == 1'b1)
                        PSR[1] <= 1'b1;
                    else if (sum[15] == 1'b1)
                        PSR[3] <= 1'b1;
                    else if (sum == 0 && carry == 1'b0)
                        PSR[4] <= 1'b1;
                    end
                4'b0110: //rotate
                    reg_file[i] <= {reg_file[j][0], reg_file[j][15:1]};
                4'b0111: //shift
                    reg_file[i] <= reg_file[j] << int;
                4'b1000: //halt
                     $stop;
                4'b1001: //complement
                    reg_file[i] <= ~reg_file[j];
        endcase
    end

    assign pc_next = (ir[31:28] != 4'b0011) ? pc1 : branch;
    
endmodule



