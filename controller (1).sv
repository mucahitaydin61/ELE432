module controller (input  logic       clk,
                   input  logic       reset,
                   input  logic [6:0] op,
                   input  logic [2:0] funct3,
                   input  logic       funct7b5,
                   input  logic       zero,
                   output logic [1:0] immsrc,
                   output logic [1:0] alusrca, alusrcb,
                   output logic [1:0] resultsrc,
                   output logic       adrsrc,
                   output logic [2:0] alucontrol,
                   output logic       irwrite, pcwrite,
                   output logic       regwrite, memwrite);

    // Internal signals between modules
    logic [1:0] aluop;
    logic       branch;
    logic       pcupdate;

    // 1. Instantiate Main FSM
    mainfsm fsm_inst (
        .clk(clk), .reset(reset), .op(op),
        .branch(branch), .pcupdate(pcupdate),
        .regwrite(regwrite), .memwrite(memwrite),
        .irwrite(irwrite), .resultsrc(resultsrc),
        .alusrcb(alusrcb), .alusrca(alusrca),
        .adrsrc(adrsrc), .aluop(aluop)
    );

    // 2. Instantiate ALU Decoder
    aludec ad_inst (
        .opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5),
        .aluop(aluop), .alucontrol(alucontrol)
    );

    // 3. Instantiate Instruction Decoder
    instrdec id_inst (
        .op(op), .immsrc(immsrc)
    );

    // PCWrite Logic
    assign pcwrite = pcupdate | (branch & zero);

endmodule