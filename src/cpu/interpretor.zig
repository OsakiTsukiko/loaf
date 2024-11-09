const std = @import("std");
const CPU = @import("./cpu.zig").CPU;
const Execution = @import("./execution.zig").Execution;

pub const Interpretor = struct {
    pub fn executeOPCode(cpu: *CPU, opcode: u8) void {
        const instr: Instruction = @as(Instruction, @enumFromInt(opcode));
        switch (instr) {
            .NOP => {},
            .STOP_n8 => {},
            .JP_NZ_e8 => {},
            .JP_NC_e8 => {},
            .LD_BC_n16 => {},
            .LD_DE_n16 => {},
            .LD_HL_n16 => {},
            .LD_SP_n16 => {},
            .LD_adr_BC_A => {},
            .LD_adr_DE_A => {},
            .LD_adr_HLI_A => {},
            .LD_adr_HLD_A => {},
            .INC_BC => {},
            .INC_DE => {},
            .INC_HL => {},
            .INC_SP => {},
            .INC_B => {},
            .INC_D => {},
            .INC_H => {},
            .INC_adr_HL => {},
            .DEC_B => {},
            .DEC_D => {},
            .DEC_H => {},
            .DEC_adr_HL => {},
            .LD_B_n8 => {},
            .LD_D_n8 => {},
            .LD_H_n8 => {},
            .LD_adr_HL_n8 => {},
            .RLCA => {},
            .RLA => {},
            .DAA => {},
            .SCF => {},
            .LD_adr_a16_SP => {},
            .JR_e8 => {},
            .JR_Z_e8 => {},
            .JR_C_e8 => {},
            .ADD_HL_BC => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.bc, 8),
            .ADD_HL_DE => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.de, 8),
            .ADD_HL_HL => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.hl, 8),
            .ADD_HL_SP => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.sp, 8),
            .LD_A_adr_BC => {},
            .LD_A_adr_DE => {},
            .LD_A_adr_HLI => {},
            .LD_A_adr_HLD => {},
            .DEC_BC => {},
            .DEC_DE => {},
            .DEC_HL => {},
            .DEC_SP => {},
            .INC_C => {},
            .INC_E => {},
            .INC_L => {},
            .INC_A => {},
            .DEC_C => {},
            .DEC_E => {},
            .DEC_L => {},
            .DEC_A => {},
            .LD_C_n8 => {},
            .LD_E_n8 => {},
            .LD_L_n8 => {},
            .LD_A_n8 => {},
            .RRCA => {},
            .RRA => {},
            .CPL => {},
            .CCF => {},
            .LD_B_B => {},
            .LD_B_C => {},
            .LD_B_D => {},
            .LD_B_E => {},
            .LD_B_H => {},
            .LD_B_L => {},
            .LD_B_adr_HL => {},
            .LD_B_A => {},
            .LD_C_B => {},
            .LD_C_C => {},
            .LD_C_D => {},
            .LD_C_E => {},
            .LD_C_H => {},
            .LD_C_L => {},
            .LD_C_adr_HL => {},
            .LD_C_A => {},
            .LD_D_B => {},
            .LD_D_C => {},
            .LD_D_D => {},
            .LD_D_E => {},
            .LD_D_H => {},
            .LD_D_L => {},
            .LD_D_adr_HL => {},
            .LD_D_A => {},
            .LD_E_B => {},
            .LD_E_C => {},
            .LD_E_D => {},
            .LD_E_E => {},
            .LD_E_H => {},
            .LD_E_L => {},
            .LD_E_adr_HL => {},
            .LD_E_A => {},
            .LD_H_B => {},
            .LD_H_C => {},
            .LD_H_D => {},
            .LD_H_E => {},
            .LD_H_H => {},
            .LD_H_L => {},
            .LD_H_adr_HL => {},
            .LD_H_A => {},
            .LD_L_B => {},
            .LD_L_C => {},
            .LD_L_D => {},
            .LD_L_E => {},
            .LD_L_H => {},
            .LD_L_L => {},
            .LD_L_adr_HL => {},
            .LD_L_A => {},
            .LD_adr_HL_B => {},
            .LD_adr_HL_C => {},
            .LD_adr_HL_D => {},
            .LD_adr_HL_E => {},
            .LD_adr_HL_H => {},
            .LD_adr_HL_L => {},
            .LD_adr_HL_A => {},
            .LD_A_B => {},
            .LD_A_C => {},
            .LD_A_D => {},
            .LD_A_E => {},
            .LD_A_H => {},
            .LD_A_L => {},
            .LD_A_adr_HL => {},
            .LD_A_A => {},
            .HALT => {},
            .ADD_A_B => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .ADD_A_C => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .ADD_A_D => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .ADD_A_E => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .ADD_A_H => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .ADD_A_L => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .ADD_A_adr_HL => Execution.add_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .ADD_A_A => Execution.add_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .ADC_A_B => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .ADC_A_C => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .ADC_A_D => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .ADC_A_E => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .ADC_A_H => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .ADC_A_L => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .ADC_A_adr_HL => Execution.adc_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .ADC_A_A => Execution.adc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .SUB_A_B => {},
            .SUB_A_C => {},
            .SUB_A_D => {},
            .SUB_A_E => {},
            .SUB_A_H => {},
            .SUB_A_L => {},
            .SUB_A_adr_HL => {},
            .SUB_A_A => {},
            .SBC_A_B => {},
            .SBC_A_C => {},
            .SBC_A_D => {},
            .SBC_A_E => {},
            .SBC_A_H => {},
            .SBC_A_L => {},
            .SBC_A_adr_HL => {},
            .SBC_A_A => {},
            .AND_A_B => {},
            .AND_A_C => {},
            .AND_A_D => {},
            .AND_A_E => {},
            .AND_A_H => {},
            .AND_A_L => {},
            .AND_A_adr_HL => {},
            .AND_A_A => {},
            .XOR_A_B => {},
            .XOR_A_C => {},
            .XOR_A_D => {},
            .XOR_A_E => {},
            .XOR_A_H => {},
            .XOR_A_L => {},
            .XOR_A_adr_HL => {},
            .XOR_A_A => {},
            .OR_A_B => {},
            .OR_A_C => {},
            .OR_A_D => {},
            .OR_A_E => {},
            .OR_A_H => {},
            .OR_A_L => {},
            .OR_A_adr_HL => {},
            .OR_A_A => {},
            .CP_A_B => {},
            .CP_A_C => {},
            .CP_A_D => {},
            .CP_A_E => {},
            .CP_A_H => {},
            .CP_A_L => {},
            .CP_A_adr_HL => {},
            .CP_A_A => {},
            .RET_NZ => {},
            .RET_NC => {},
            .LDH_adr_a8_A => {},
            .LDH_A_adr_a8 => {},
            .POP_BC => {},
            .POP_DE => {},
            .POP_HL => {},
            .POP_AF => {},
            .JP_NZ_a16 => {},
            .JP_NC_a16 => {},
            .LD_adr_C_A => {},
            .LD_A_adr_C => {},
            .JP_a16 => {},
            .DI => {},
            .CALL_NZ_a16 => {},
            .CALL_NC_a16 => {},
            .PUSH_BC => {},
            .PUSH_DE => {},
            .PUSH_HL => {},
            .PUSH_AF => {},
            .ADD_A_n8 => Execution.add_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .SUB_A_n8 => {},
            .AND_A_n8 => {},
            .OR_A_n8 => {},
            .RST_0 => {},
            .RST_2 => {},
            .RST_4 => {},
            .RST_6 => {},
            .RET_Z => {},
            .RET_C => {},
            .ADD_SP_e8 => Execution.add_sp_e8(cpu, 16),
            .LD_HL_SP_plus_e8 => {},
            .RET => {},
            .RETI => {},
            .JP_HL => {},
            .LD_SP_HL => {},
            .JP_Z_a16 => {},
            .JP_C_a16 => {},
            .LD_adr_a16_A => {},
            .LD_A_adr_a16 => {},
            .PREFIX => {},
            .EI => {},
            .CALL_Z_a16 => {},
            .CALL_C_a16 => {},
            .CALL_a16 => {},
            .ADC_A_n8 => Execution.adc_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .SBC_A_n8 => {},
            .XOR_A_n8 => {},
            .CP_A_n8 => {},
            .RST_1 => {},
            .RST_3 => {},
            .RST_5 => {},
            .RST_7 => {},
        }
    }

    pub const Instruction = enum(u8) {
        //0-40
        NOP = 0x00,
        STOP_n8 = 0x10,
        // jumps
        JP_NZ_e8 = 0x20,
        JP_NC_e8 = 0x30,
        // 0-41
        LD_BC_n16 = 0x01,
        LD_DE_n16 = 0x11,
        LD_HL_n16 = 0x21,
        LD_SP_n16 = 0x31,
        // 0-42
        LD_adr_BC_A = 0x02,
        LD_adr_DE_A = 0x12,
        LD_adr_HLI_A = 0x22,
        LD_adr_HLD_A = 0x32,
        // 0-43
        INC_BC = 0x03,
        INC_DE = 0x13,
        INC_HL = 0x23,
        INC_SP = 0x33,
        // 0-44
        INC_B = 0x04,
        INC_D = 0x14,
        INC_H = 0x24,
        INC_adr_HL = 0x34,
        // 0-45
        DEC_B = 0x05,
        DEC_D = 0x15,
        DEC_H = 0x25,
        DEC_adr_HL = 0x35,
        // 0-46
        LD_B_n8 = 0x06,
        LD_D_n8 = 0x16,
        LD_H_n8 = 0x26,
        LD_adr_HL_n8 = 0x36,
        // 0-47
        RLCA = 0x07,
        RLA = 0x17,
        DAA = 0x27,
        SCF = 0x37,
        // 0-48
        LD_adr_a16_SP = 0x08,
        JR_e8 = 0x18,
        JR_Z_e8 = 0x28,
        JR_C_e8 = 0x38,
        // 0-49
        ADD_HL_BC = 0x09,
        ADD_HL_DE = 0x19,
        ADD_HL_HL = 0x29,
        ADD_HL_SP = 0x39,
        // 0-4A
        LD_A_adr_BC = 0x0A,
        LD_A_adr_DE = 0x1A,
        LD_A_adr_HLI = 0x2A,
        LD_A_adr_HLD = 0x3A,
        // 0-4B
        DEC_BC = 0x0B,
        DEC_DE = 0x1B,
        DEC_HL = 0x2B,
        DEC_SP = 0x3B,
        // 0-4C
        INC_C = 0x0C,
        INC_E = 0x1C,
        INC_L = 0x2C,
        INC_A = 0x3C,
        // 0-4D
        DEC_C = 0x0D,
        DEC_E = 0x1D,
        DEC_L = 0x2D,
        DEC_A = 0x3D,
        // 0-4E
        LD_C_n8 = 0x0E,
        LD_E_n8 = 0x1E,
        LD_L_n8 = 0x2E,
        LD_A_n8 = 0x3E,
        // 0-4F
        RRCA = 0x0F,
        RRA = 0x1F,
        CPL = 0x2F,
        CCF = 0x3F,
        // 
        //
        // 4x
        LD_B_B = 0x40,
        LD_B_C = 0x41,
        LD_B_D = 0x42,
        LD_B_E = 0x43,
        LD_B_H = 0x44,
        LD_B_L = 0x45,
        LD_B_adr_HL = 0x46,
        LD_B_A = 0x47,
        LD_C_B = 0x48,
        LD_C_C = 0x49,
        LD_C_D = 0x4A,
        LD_C_E = 0x4B,
        LD_C_H = 0x4C,
        LD_C_L = 0x4D,
        LD_C_adr_HL = 0x4E,
        LD_C_A = 0x4F,
        // 5x
        LD_D_B = 0x50,
        LD_D_C = 0x51,
        LD_D_D = 0x52,
        LD_D_E = 0x53,
        LD_D_H = 0x54,
        LD_D_L = 0x55,
        LD_D_adr_HL = 0x56,
        LD_D_A = 0x57,
        LD_E_B = 0x58,
        LD_E_C = 0x59,
        LD_E_D = 0x5A,
        LD_E_E = 0x5B,
        LD_E_H = 0x5C,
        LD_E_L = 0x5D,
        LD_E_adr_HL = 0x5E,
        LD_E_A = 0x5F,
        // 6x
        LD_H_B = 0x60,
        LD_H_C = 0x61,
        LD_H_D = 0x62,
        LD_H_E = 0x63,
        LD_H_H = 0x64,
        LD_H_L = 0x65,
        LD_H_adr_HL = 0x66,
        LD_H_A = 0x67,
        LD_L_B = 0x68,
        LD_L_C = 0x69,
        LD_L_D = 0x6A,
        LD_L_E = 0x6B,
        LD_L_H = 0x6C,
        LD_L_L = 0x6D,
        LD_L_adr_HL = 0x6E,
        LD_L_A = 0x6F,
        // 7x
        LD_adr_HL_B = 0x70,
        LD_adr_HL_C = 0x71,
        LD_adr_HL_D = 0x72,
        LD_adr_HL_E = 0x73,
        LD_adr_HL_H = 0x74,
        LD_adr_HL_L = 0x75,
        LD_adr_HL_A = 0x77,
        LD_A_B = 0x78,
        LD_A_C = 0x79,
        LD_A_D = 0x7A,
        LD_A_E = 0x7B,
        LD_A_H = 0x7C,
        LD_A_L = 0x7D,
        LD_A_adr_HL = 0x7E,
        LD_A_A = 0x7F,
        // 7xMISC
        HALT = 0x76,
        //
        //
        // 8x
        ADD_A_B = 0x80,
        ADD_A_C = 0x81,
        ADD_A_D = 0x82,
        ADD_A_E = 0x83,
        ADD_A_H = 0x84,
        ADD_A_L = 0x85,
        ADD_A_adr_HL = 0x86,
        ADD_A_A = 0x87,
        ADC_A_B = 0x88,
        ADC_A_C = 0x89,
        ADC_A_D = 0x8A,
        ADC_A_E = 0x8B,
        ADC_A_H = 0x8C,
        ADC_A_L = 0x8D,
        ADC_A_adr_HL = 0x8E,
        ADC_A_A = 0x8F,
        // 9x
        SUB_A_B = 0x90,
        SUB_A_C = 0x91,
        SUB_A_D = 0x92,
        SUB_A_E = 0x93,
        SUB_A_H = 0x94,
        SUB_A_L = 0x95,
        SUB_A_adr_HL = 0x96,
        SUB_A_A = 0x97,
        SBC_A_B = 0x98,
        SBC_A_C = 0x99,
        SBC_A_D = 0x9A,
        SBC_A_E = 0x9B,
        SBC_A_H = 0x9C,
        SBC_A_L = 0x9D,
        SBC_A_adr_HL = 0x9E,
        SBC_A_A = 0x9F,
        // Ax
        AND_A_B = 0xA0,
        AND_A_C = 0xA1,
        AND_A_D = 0xA2,
        AND_A_E = 0xA3,
        AND_A_H = 0xA4,
        AND_A_L = 0xA5,
        AND_A_adr_HL = 0xA6,
        AND_A_A = 0xA7,
        XOR_A_B = 0xA8,
        XOR_A_C = 0xA9,
        XOR_A_D = 0xAA,
        XOR_A_E = 0xAB,
        XOR_A_H = 0xAC,
        XOR_A_L = 0xAD,
        XOR_A_adr_HL = 0xAE,
        XOR_A_A = 0xAF,
        // Bx
        OR_A_B = 0xB0,
        OR_A_C = 0xB1,
        OR_A_D = 0xB2,
        OR_A_E = 0xB3,
        OR_A_H = 0xB4,
        OR_A_L = 0xB5,
        OR_A_adr_HL = 0xB6,
        OR_A_A = 0xB7,
        CP_A_B = 0xB8,
        CP_A_C = 0xB9,
        CP_A_D = 0xBA,
        CP_A_E = 0xBB,
        CP_A_H = 0xBC,
        CP_A_L = 0xBD,
        CP_A_adr_HL = 0xBE,
        CP_A_A = 0xBF,
        //
        //
        // C-F0
        RET_NZ = 0xC0,
        RET_NC = 0xD0,
        LDH_adr_a8_A = 0xE0,
        LDH_A_adr_a8 = 0xF0,
        // C-F1
        POP_BC = 0xC1,
        POP_DE = 0xD1,
        POP_HL = 0xE1,
        POP_AF = 0xF1,
        // C-F2
        JP_NZ_a16 = 0xC2,
        JP_NC_a16 = 0xD2,
        LD_adr_C_A = 0xE2,
        LD_A_adr_C = 0xF2,
        // C-F3
        JP_a16 = 0xC3,
        // NOPE = 0xD3,
        // NOPE = 0xE3,
        DI = 0xF3,
        // C-F4
        CALL_NZ_a16 = 0xC4,
        CALL_NC_a16 = 0xD4,
        // NOPE = 0xE4,
        // NOPE = 0xF4,
        // C-F5
        PUSH_BC = 0xC5,
        PUSH_DE = 0xD5,
        PUSH_HL = 0xE5,
        PUSH_AF = 0xF5,
        // C-F6
        ADD_A_n8 = 0xC6,
        SUB_A_n8 = 0xD6,
        AND_A_n8 = 0xE6,
        OR_A_n8 = 0xF6,
        // C-F7
        RST_0 = 0xC7,
        RST_2 = 0xD7,
        RST_4 = 0xE7,
        RST_6 = 0xF7,
        // C-F8
        RET_Z = 0xC8,
        RET_C = 0xD8,
        ADD_SP_e8 = 0xE8,
        LD_HL_SP_plus_e8 = 0xF8,
        // C-F9
        RET = 0xC9,
        RETI = 0xD9,
        JP_HL = 0xE9,
        LD_SP_HL = 0xF9,
        // C-FA
        JP_Z_a16 = 0xCA,
        JP_C_a16 = 0xDA,
        LD_adr_a16_A = 0xEA,
        LD_A_adr_a16 = 0xFA,
        // C-FB
        PREFIX = 0xCB,
        // NOPE = 0xDB,
        // NOPE = 0xEB,
        EI = 0xFB,
        // C-FC
        CALL_Z_a16 = 0xCC,
        CALL_C_a16 = 0xDC,
        // NOPE = 0xEC,
        // NOPE = 0xFC,
        // C-FD
        CALL_a16 = 0xCD,
        // NOPE = 0xDD,
        // NOPE = 0xED,
        // NOPE = 0xFD,
        // C-FE
        ADC_A_n8 = 0xCE,
        SBC_A_n8 = 0xDE,
        XOR_A_n8 = 0xEE,
        CP_A_n8 = 0xFE,
        // C-FF
        RST_1 = 0xCF,
        RST_3 = 0xDF,
        RST_5 = 0xEF,
        RST_7 = 0xFF,
    };
};