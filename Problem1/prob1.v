module prob1(C, overflow, A, B, alu_code);
    output reg [15:0] C;
    output reg overflow;
    input [15:0] A, B;
    input [4:0] alu_code;
    reg vout, cout; 
    reg [16:0] temp;
    reg signed [15:0] A_signed, B_signed;
    always @ (A or B or alu_code) begin
    A_signed = A; 
    B_signed = B;
    case(alu_code[4:3])
        2'b00:
            case(alu_code[2:0])
                3'b000: begin 
                            temp = A_signed + B_signed;
                            cout = temp[16];
                            C = temp[15:0];
                            if (A_signed[15] == 1'b0 && B_signed[15] == 1'b0 && C[15] == 1'b1)
                                vout = 1'b1;
                            else if (A_signed[15] == 1'b1 && B_signed[15] == 1'b1 && C[15] == 1'b0)
                                vout = 1'b1;
                            else 
                                vout = 1'b0;
                        end
                3'b001: begin
                            vout = 1'b0;
                            temp = A + B;
                            cout = temp[16];
                            C = temp[15:0];
                        end
                3'b010: begin 
                            temp = A_signed - B_signed;
                            cout = temp[16];
                            C = temp[15:0];
                            if (A_signed[15] == 1'b0 && B_signed[15] == 1'b0 && C[15] == 1'b1)
                                vout = 1'b1;
                            else if (A_singed[15] == 1'b1 && B_signed[15] == 1'b1 && C[15] == 1'b0)
                                vout = 1'b1;
                            else 
                                vout = 1'b0;
                        end
                3'b011: begin
                            vout = 1'b0;
                            temp = A - B;
                            cout = temp[16];
                            C = temp[15:0];
                        end
                3'b100: begin 
                            temp = A_signed + 1'b1;
                            cout = temp[16];
                            C = temp[15:0];
                            if (A_signed[15] == 1'b0 && B_signed[15] == 1'b0 && C[15] == 1'b1)
                                vout = 1'b1;
                            else if (A_signed[15] == 1'b1 && B_signed[15] == 1'b1 && C[15] == 1'b0)
                                vout = 1'b1;
                            else 
                                vout = 1'b0;
                        end
                3'b101: begin 
                            temp = A_signed - 1'b1;
                            cout = temp[16];
                            C = temp[15:0];
                            if (A_signed[15] == 1'b0 && B_signed[15] == 1'b0 && C[15] == 1'b1)
                                vout = 1'b1;
                            else if (A_signed[15] == 1'b1 && B_signed[15] == 1'b1 && C[15] == 1'b0)
                                vout = 1'b1;
                            else 
                                vout = 1'b0;
                        end 
                endcase                    
            
        2'b01:
            case(alu_code[2:0])
                3'b000: begin
                            C = A && B;
                            overflow = 1'b0;
                        end
                3'b001: begin
                            C = A || B;
                            overflow = 1'b0;
                        end
                3'b010: begin
                            C = (A && ~B) || (~A && B);
                            overflow = 1'b0;
                        end
                3'b100: begin
                            C = ~A;
                            overflow = 1'b0;
                        end
            endcase
        2'b10:
            case(alu_code[2:0])
                3'b000: begin                  
                            C = A << B;
                            overflow = 1'b0;
                        end
                3'b001: begin
                            C = A >> B;
                            overflow = 1'b0;
                        end
                3'b010: begin
                            C = A <<< B;
                            overflow = 1'b0; 
                        end
                3'b011: begin
                            C = A >>> B;
                            overflow = 1'b0;
                        end
            endcase
        2'b11:
            case(alu_code[2:0])
                3'b000: begin
                            overflow = 1'b0;
                            if (A <= B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end                           
                3'b001: begin
                            overflow = 1'b0;
                            if (A < B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end   
                3'b010: begin
                            overflow = 1'b0;
                            if (A >= B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end   
                3'b011: begin
                            overflow = 1'b0;
                            if (A > B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end   
                3'b100: begin
                            overflow = 1'b0;
                            if (A == B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end   
                3'b101: begin
                            overflow = 1'b0;
                            if (A != B) 
                                C = 16'b0000000000000001;
                            else
                                C = 16'b0000000000000000; 
                        end   
            endcase
    endcase
    end
endmodule
    




