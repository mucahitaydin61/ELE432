module aludec(input  logic       opb5,
              input  logic [2:0] funct3,
              input  logic       funct7b5,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol);

    logic RtypeSub;
    assign RtypeSub = funct7b5 & opb5; // TRUE for R-type subtract instruction

    always_comb case(aluop)
        2'b00: alucontrol = 3'b010; // addition (lw, sw, etc.) - Expected by testbench: 010
        2'b01: alucontrol = 3'b110; // subtraction (beq)       - Expected by testbench: 110
        default: case(funct3)       // R-type or I-type ALU
            3'b000: if (RtypeSub) alucontrol = 3'b110; // sub
                    else          alucontrol = 3'b010; // add, addi
            3'b010: alucontrol = 3'b111; // slt, slti
            3'b110: alucontrol = 3'b001; // or, ori
            3'b111: alucontrol = 3'b000; // and, andi
            default: alucontrol = 3'bxxx; // unknown
        endcase
    endcase
endmodule