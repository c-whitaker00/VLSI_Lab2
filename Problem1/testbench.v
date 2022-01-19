module testbench;
    wire [15:0] C;
    wire overflow;
    reg [15:0] A, B;
    reg [4:0] alu_code;
    localparam period = 20;

    prob1 DUT(.C(C), .overflow(overflow), .A(A), .B(B), .alu_code(alu_code));
    initial begin
        A = 16'd250;
        B = 16'd10;
        alu_code = 5'b00000;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("Adding signed!");
        #period
        #period
        $display("Output %p", C);

        A = 16'd2010;
        B = 16'd390;
        alu_code = 5'b00001;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("Adding unsign!");
        #period
        #period
        $display("Output %p", C);

        A = 16'd250;
        B = 16'd10;
        alu_code = 5'b00101;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("Decrement!");
        #period
        #period
        $display("Output %p", C);

        A = 16'd250;
        B = 16'd10;
        alu_code = 5'b00011;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("Subtracting!");
        #period
        #period
        $display("Output %p", C);

        A = 16'd1;
        B = 16'd1;
        alu_code = 5'b01000;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("A AND B?");
        #period
        #period
        $display("Output %p", C);


        A = 16'd1;
        B = 16'd1;
        alu_code = 5'b01001;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("A OR B?");
        #period
        #period
        $display("Output %p", C);

        A = 16'd7;
        B = 16'd2;
        alu_code = 5'b10001;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("Shift left!");
        #period
        #period
        $display("Output %p", C);

        A = 16'd16;
        B = 16'd5;
        alu_code = 5'b11010;
        $display("Input %p", A);
        $display("Input %p", B);
        $display("A greater than or equal to B?");
        #period
        #period
        $display("Output %p", C);
    end
endmodule
