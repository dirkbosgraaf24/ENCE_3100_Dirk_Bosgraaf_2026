


module main(
    input        MAX10_CLK1_50,
    input  [1:0] KEY,
    input  [9:0] SW,
    inout  [35:0] GPIO,
    output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX4,
    output [7:0] HEX5
	 
	 
);

localparam N = 4;

// ------------------------------
// 
// ------------------------------
wire w_reset = SW[8];

wire switch_clean;
wire press_pulse;

switch_debounce #(
    .DEBOUNCE_CYCLES(500_000)        // 10 ms @ 50 MHz
) DB1 (
    .clk          (MAX10_CLK1_50),   // debouncer runs on the 50 MHz clock
    .reset        (w_reset),
    .switch_in    (SW[9]),
    .switch_clean (switch_clean),
    .press_pulse  (press_pulse)
);

wire w_clock = switch_clean;         // CPU steps once per clean switch flip

// ------------------------------
// User Wires
// ------------------------------
wire [N-1:0] w_user_input = SW[3:0];

wire w_carry;
assign LEDR[9] = w_carry;

wire [N-1:0] w_rOut;
assign LEDR[3:0] = w_rOut;

assign LEDR[8:4] = 5'b0;             // unused LEDs
// DEBUG: replace the line above with:
// assign LEDR[8] = 1'b0; assign LEDR[7:4] = w_AluA;

// ------------------------------
// Internal Wires
// ------------------------------
wire [N-1:0] w_IB_BUS;
wire [N-1:0] w_AluA;
wire [N-1:0] w_AluB;

wire [N-1:0] w_counter;
wire [N-1:0] w_data;
wire [N-1:0] w_instruction;

// ------------------------------
// FSM Control Wires
// ------------------------------
wire w_LatchA;
wire w_EnableA;
wire w_LatchB;
wire w_EnableALU;
wire w_AddSub;
wire w_EnableIN;
wire w_EnableOut;
wire w_LoadInstr;
wire w_EnableInstr;
wire [N-1:0] w_ToInstr;
wire w_EnableCount;

// ------------------------------
// Accumulator A
// ------------------------------
Accumulator_A AccA (
    .MainClock(w_clock),
    .ClearA   (w_reset),
    .LatchA   (w_LatchA),
    .EnableA  (w_EnableA),
    .A        (w_IB_BUS),
    .IB_BUS   (w_IB_BUS),
    .AluA     (w_AluA)
);

seg7Decoder SEG1 (.i_bin(w_AluA), .o_HEX(HEX1));

// ------------------------------
// Accumulator B
// ------------------------------
Accumulator_B AccB (
    .MainClock(w_clock),
    .ClearB   (w_reset),
    .LatchB   (w_LatchB),
    .B        (w_IB_BUS),
    .AluB     (w_AluB)
);

seg7Decoder SEG2 (.i_bin(w_AluB), .o_HEX(HEX2));

// ------------------------------
// ALU
// ------------------------------
Arithmetic_Unit ALU (
    .EnableALU(w_EnableALU),
    .AddSub   (w_AddSub),
    .A        (w_AluA),
    .B        (w_AluB),
    .Carry    (w_carry),
    .IB_ALU   (w_IB_BUS)
);

seg7Decoder SEG0 (.i_bin(w_IB_BUS), .o_HEX(HEX0));

// ------------------------------
// Input Register
// ------------------------------
InRegister InReg (
    .EnableIN(w_EnableIN),
    .DataIn  (w_user_input),
    .IB_BUS  (w_IB_BUS)
);

seg7Decoder SEG4 (.i_bin(w_user_input), .o_HEX(HEX4));

// ------------------------------
// Output Register
// ------------------------------
OutRegister OutReg (
    .MainClock(w_clock),
    .MainReset(w_reset),
    .EnableOut(w_EnableOut),
    .IB_BUS   (w_IB_BUS),
    .rOut     (w_rOut)
);

seg7Decoder SEG5 (.i_bin(w_rOut), .o_HEX(HEX5));

// ------------------------------
// Instruction Register
// ------------------------------
InstructionReg InstrReg (
    .MainClock  (w_clock),
    .ClearInstr (w_reset),
    .LatchInstr (w_LoadInstr),
    .EnableInstr(w_EnableInstr),
    .Data       (w_data),
    .Instr      (w_instruction),
    .ToInstr    (w_ToInstr),   // output: opcode -> FSM
    .IB_BUS     (w_IB_BUS)
);

// ------------------------------
// Program Counter
// ------------------------------
ProgramCounter ProgCounter (
    .MainClock   (w_clock),
    .EnableCount (w_EnableCount),
    .ClearCounter(w_reset),
    .Counter     (w_counter)
);

// ------------------------------
// ROM 8x8
// ------------------------------
wire [7:0] w_rom_data;

ROM_Nx8 ROM (
    .address(w_counter[2:0]),
    .data   (w_rom_data)
);

assign {w_instruction, w_data} = w_rom_data;

// ------------------------------
// Microinstruction FSM
// ------------------------------
FSM_MicroInstr Controller (
    .clk        (w_clock),
    .reset      (w_reset),
    .IB_BUS     (w_IB_BUS),
    .LatchA     (w_LatchA),
    .EnableA    (w_EnableA),
    .LatchB     (w_LatchB),
    .EnableALU  (w_EnableALU),
    .AddSub     (w_AddSub),
    .EnableIN   (w_EnableIN),
    .EnableOut  (w_EnableOut),
    .LoadInstr  (w_LoadInstr),
    .EnableInstr(w_EnableInstr),
    .ToInstr    (w_ToInstr),   // input: opcode from InstrReg
    .EnableCount(w_EnableCount)
);

endmodule

