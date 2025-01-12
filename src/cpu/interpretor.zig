const std = @import("std");
const CPU = @import("./cpu.zig").CPU;
const Execution = @import("./execution.zig").Execution;

pub const Interpretor = struct {
    pub fn executeOPCode(cpu: *CPU, opcode: u8) void {
        const instr: Instruction = @as(Instruction, @enumFromInt(opcode));
        switch (instr) {
            .NOP => { cpu.waitCycles(4); },
            .STOP_n8 => { cpu.waitCycles(4); unreachable; },
            .JR_NZ_e8 => Execution.jr_nz_n8(cpu, 0),
            .JR_NC_e8 => Execution.jr_nc_n8(cpu, 0),
            .LD_BC_n16 => Execution.ld_r16_v16(cpu, &cpu.registers.r16.bc, cpu.next2OPCode(), 12),
            .LD_DE_n16 => Execution.ld_r16_v16(cpu, &cpu.registers.r16.de, cpu.next2OPCode(), 12),
            .LD_HL_n16 => Execution.ld_r16_v16(cpu, &cpu.registers.r16.hl, cpu.next2OPCode(), 12),
            .LD_SP_n16 => Execution.ld_r16_v16(cpu, &cpu.registers.r16.sp, cpu.next2OPCode(), 12),
            .LD_adr_BC_A => Execution.ld_adr_r8(cpu, cpu.registers.r16.bc, &cpu.registers.r8.l.a, 8),
            .LD_adr_DE_A => Execution.ld_adr_r8(cpu, cpu.registers.r16.de, &cpu.registers.r8.l.a, 8),
            .LD_adr_HLI_A => {
                Execution.ld_adr_v8(cpu, cpu.registers.r16.hl, cpu.registers.r8.l.a, 8);
                cpu.registers.r16.hl +%= 1;
            },
            .LD_adr_HLD_A => {
                Execution.ld_adr_v8(cpu, cpu.registers.r16.hl, cpu.registers.r8.l.a, 8);
                cpu.registers.r16.hl -%= 1;
            },
            .INC_BC => Execution.inc_r16(cpu, &cpu.registers.r16.bc, 8),
            .INC_DE => Execution.inc_r16(cpu, &cpu.registers.r16.de, 8),
            .INC_HL => Execution.inc_r16(cpu, &cpu.registers.r16.hl, 8),
            .INC_SP => Execution.inc_r16(cpu, &cpu.registers.r16.sp, 8),
            .INC_B => Execution.inc_r8(cpu, &cpu.registers.r8.l.b, 4),
            .INC_D => Execution.inc_r8(cpu, &cpu.registers.r8.l.d, 4),
            .INC_H => Execution.inc_r8(cpu, &cpu.registers.r8.l.h, 4),
            .INC_adr_HL => Execution.inc_adr(cpu, cpu.registers.r16.hl, 12),
            .DEC_B => Execution.dec_r8(cpu, &cpu.registers.r8.l.b, 4),
            .DEC_D => Execution.dec_r8(cpu, &cpu.registers.r8.l.d, 4),
            .DEC_H => Execution.dec_r8(cpu, &cpu.registers.r8.l.h, 4),
            .DEC_adr_HL => Execution.dec_adr(cpu, cpu.registers.r16.hl, 12),
            .LD_B_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.b, cpu.nextOPCode(), 8),
            .LD_D_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.d, cpu.nextOPCode(), 8),
            .LD_H_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.h, cpu.nextOPCode(), 8),
            .LD_adr_HL_n8 => Execution.ld_adr_v8(cpu, cpu.registers.r16.hl, cpu.nextOPCode(), 12),
            .RLCA => Execution.rlca(cpu, 4),
            .RLA => Execution.rla(cpu, 4),
            .DAA => Execution.daa(cpu, 4),
            .SCF => Execution.scf(cpu, 4),
            .LD_adr_a16_SP => Execution.ld_adr_SP(cpu, 20),
            .JR_e8 => Execution.jr_n8(cpu, 0),
            .JR_Z_e8 => Execution.jr_z_n8(cpu, 0),
            .JR_C_e8 => Execution.jr_c_n8(cpu, 0),
            .ADD_HL_BC => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.bc, 8),
            .ADD_HL_DE => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.de, 8),
            .ADD_HL_HL => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.hl, 8),
            .ADD_HL_SP => Execution.add_r16_r16(cpu, cpu.registers.r16.hl, cpu.registers.r16.sp, 8),
            .LD_A_adr_BC => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.bc), 8),
            .LD_A_adr_DE => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.de), 8),
            .LD_A_adr_HLI => {
                Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8);
                cpu.registers.r16.hl +%= 1;
            },
            .LD_A_adr_HLD => {
                Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8);
                cpu.registers.r16.hl -%= 1;
            },
            .DEC_BC => Execution.dec_r16(cpu, &cpu.registers.r16.bc, 8),
            .DEC_DE => Execution.dec_r16(cpu, &cpu.registers.r16.de, 8),
            .DEC_HL => Execution.dec_r16(cpu, &cpu.registers.r16.hl, 8),
            .DEC_SP => Execution.dec_r16(cpu, &cpu.registers.r16.sp, 8),
            .INC_C => Execution.inc_r8(cpu, &cpu.registers.r8.l.c, 4),
            .INC_E => Execution.inc_r8(cpu, &cpu.registers.r8.l.e, 4),
            .INC_L => Execution.inc_r8(cpu, &cpu.registers.r8.l.l, 4),
            .INC_A => Execution.inc_r8(cpu, &cpu.registers.r8.l.a, 4),
            .DEC_C => Execution.dec_r8(cpu, &cpu.registers.r8.l.c, 4),
            .DEC_E => Execution.dec_r8(cpu, &cpu.registers.r8.l.e, 4),
            .DEC_L => Execution.dec_r8(cpu, &cpu.registers.r8.l.l, 4),
            .DEC_A => Execution.dec_r8(cpu, &cpu.registers.r8.l.a, 4),
            .LD_C_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.c, cpu.nextOPCode(), 8),
            .LD_E_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.e, cpu.nextOPCode(), 8),
            .LD_L_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.l, cpu.nextOPCode(), 8),
            .LD_A_n8 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.nextOPCode(), 8),
            .RRCA => Execution.rrca(cpu, 4),
            .RRA => Execution.rra(cpu, 4),
            .CPL => Execution.cpl(cpu, 4),
            .CCF => Execution.ccf(cpu, 4),
            .LD_B_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.b, 4),
            .LD_B_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.c, 4),
            .LD_B_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.d, 4),
            .LD_B_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.e, 4),
            .LD_B_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.h, 4),
            .LD_B_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.l, 4),
            .LD_B_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.b, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_B_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.b, &cpu.registers.r8.l.a, 4),
            .LD_C_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.b, 4),
            .LD_C_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.c, 4),
            .LD_C_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.d, 4),
            .LD_C_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.e, 4),
            .LD_C_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.h, 4),
            .LD_C_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.l, 4),
            .LD_C_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.c, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_C_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.c, &cpu.registers.r8.l.a, 4),
            .LD_D_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.b, 4),
            .LD_D_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.c, 4),
            .LD_D_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.d, 4),
            .LD_D_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.e, 4),
            .LD_D_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.h, 4),
            .LD_D_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.l, 4),
            .LD_D_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.d, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_D_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.d, &cpu.registers.r8.l.a, 4),
            .LD_E_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.b, 4),
            .LD_E_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.c, 4),
            .LD_E_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.d, 4),
            .LD_E_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.e, 4),
            .LD_E_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.h, 4),
            .LD_E_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.l, 4),
            .LD_E_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.e, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_E_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.e, &cpu.registers.r8.l.a, 4),
            .LD_H_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.b, 4),
            .LD_H_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.c, 4),
            .LD_H_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.d, 4),
            .LD_H_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.e, 4),
            .LD_H_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.h, 4),
            .LD_H_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.l, 4),
            .LD_H_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.h, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_H_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.h, &cpu.registers.r8.l.a, 4),
            .LD_L_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.b, 4),
            .LD_L_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.c, 4),
            .LD_L_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.d, 4),
            .LD_L_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.e, 4),
            .LD_L_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.h, 4),
            .LD_L_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.l, 4),
            .LD_L_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.l, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_L_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.l, &cpu.registers.r8.l.a, 4),
            .LD_adr_HL_B => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.b, 8),
            .LD_adr_HL_C => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.c, 8),
            .LD_adr_HL_D => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.d, 8),
            .LD_adr_HL_E => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.e, 8),
            .LD_adr_HL_H => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.h, 8),
            .LD_adr_HL_L => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.l, 8),
            .LD_adr_HL_A => Execution.ld_adr_r8(cpu, cpu.registers.r16.hl, &cpu.registers.r8.l.a, 8),
            .LD_A_B => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .LD_A_C => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .LD_A_D => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .LD_A_E => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .LD_A_H => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .LD_A_L => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .LD_A_adr_HL => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .LD_A_A => Execution.ld_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .HALT => { if (cpu.enable_interrupts_master) cpu.is_halted = true; },
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
            .SUB_A_B => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.b, 4),
            .SUB_A_C => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.c, 4),
            .SUB_A_D => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.d, 4),
            .SUB_A_E => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.e, 4),
            .SUB_A_H => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.h, 4),
            .SUB_A_L => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.l, 4),
            .SUB_A_adr_HL => Execution.sub_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .SUB_A_A => Execution.sub_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.register.r8.l.a, 4),
            .SBC_A_B => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .SBC_A_C => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .SBC_A_D => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .SBC_A_E => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .SBC_A_H => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .SBC_A_L => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .SBC_A_adr_HL => Execution.sbc_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .SBC_A_A => Execution.sbc_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .AND_A_B => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .AND_A_C => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .AND_A_D => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .AND_A_E => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .AND_A_H => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .AND_A_L => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .AND_A_adr_HL => Execution.and_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .AND_A_A => Execution.and_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .XOR_A_B => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .XOR_A_C => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .XOR_A_D => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .XOR_A_E => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .XOR_A_H => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .XOR_A_L => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .XOR_A_adr_HL => Execution.xor_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .XOR_A_A => Execution.xor_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .OR_A_B => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .OR_A_C => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .OR_A_D => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .OR_A_E => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .OR_A_H => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .OR_A_L => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .OR_A_adr_HL => Execution.or_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .OR_A_A => Execution.or_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .CP_A_B => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.b, 4),
            .CP_A_C => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.c, 4),
            .CP_A_D => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.d, 4),
            .CP_A_E => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.e, 4),
            .CP_A_H => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.h, 4),
            .CP_A_L => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.l, 4),
            .CP_A_adr_HL => Execution.cp_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.registers.r16.hl), 8),
            .CP_A_A => Execution.cp_r8_r8(cpu, &cpu.registers.r8.l.a, &cpu.registers.r8.l.a, 4),
            .RET_NZ => Execution.ret_nz(cpu, 0),
            .RET_NC => Execution.ret_nc(cpu, 0),
            .LDH_adr_a8_A => Execution.ldh_adr_n8_a(cpu, 12),
            .LDH_A_adr_a8 => Execution.ldh_a_adr_n8(cpu, 12),
            .POP_BC => Execution.pop_r16(cpu, &cpu.registers.r16.bc, 12),
            .POP_DE => Execution.pop_r16(cpu, &cpu.registers.r16.de, 12),
            .POP_HL => Execution.pop_r16(cpu, &cpu.registers.r16.hl, 12),
            .POP_AF => Execution.pop_r16(cpu, &cpu.registers.r16.af, 12),
            .JP_NZ_a16 => Execution.jp_nz_n16(cpu, 0),
            .JP_NC_a16 => Execution.jp_nc_n16(cpu, 0),
            .LD_adr_C_A => Execution.ld_c_a(cpu, 8),
            .LD_A_adr_C => Execution.ld_a_c(cpu, 8),
            .JP_a16 => Execution.jp_n16(cpu, 0),
            .DI => { cpu.waitCycles(4); cpu.enable_interrupts_master = false; },
            .CALL_NZ_a16 => Execution.call_nz(cpu, 0),
            .CALL_NC_a16 => Execution.call_nc(cpu, 0),
            .PUSH_BC => Execution.push_r16(cpu, &cpu.registers.r16.bc, 16),
            .PUSH_DE => Execution.push_r16(cpu, &cpu.registers.r16.de, 16),
            .PUSH_HL => Execution.push_r16(cpu, &cpu.registers.r16.hl, 16),
            .PUSH_AF => Execution.push_r16(cpu, &cpu.registers.r16.af, 16),
            .ADD_A_n8 => Execution.add_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .SUB_A_n8 => Execution.sub_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .AND_A_n8 => Execution.and_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .OR_A_n8 => Execution.or_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .RST_0 => Execution.call_v16(cpu, 0x00, 16),
            .RST_2 => Execution.call_v16(cpu, 0x10, 16),
            .RST_4 => Execution.call_v16(cpu, 0x20, 16),
            .RST_6 => Execution.call_v16(cpu, 0x30, 16),
            .RET_Z => Execution.ret_z(cpu, 0),
            .RET_C => Execution.ret_c(cpu, 0),
            .ADD_SP_e8 => Execution.add_sp_e8(cpu, 16),
            .LD_HL_SP_plus_e8 => Execution.ld_hl_sp_n8(cpu, 12),
            .RET => Execution.ret(cpu, 16),
            .RETI => Execution.reti(cpu, 16),
            .JP_HL => Execution.jp_hl(cpu, 4),
            .LD_SP_HL => Execution.ld_r16_v16(cpu, &cpu.registers.r16.sp, cpu.registers.r16.hl, 8),
            .JP_Z_a16 => Execution.jp_z_n16(cpu, 0),
            .JP_C_a16 => Execution.jp_c_n16(cpu, 0),
            .LD_adr_a16_A => Execution.ld_adr_r8(cpu, cpu.next2OPCode(), &cpu.registers.r8.l.a, 16),
            .LD_A_adr_a16 => Execution.ld_r8_v8(cpu, &cpu.registers.r8.l.a, cpu.bus.read_byte(cpu.next2OPCode()), 16),
            .PREFIX => executePrefixOPCode(cpu, cpu.nextOPCode()),
            .EI => { cpu.waitCycles(4); cpu.enable_interrupts_master = true; },
            .CALL_Z_a16 => Execution.call_z(cpu, 0),
            .CALL_C_a16 => Execution.call_c(cpu, 0),
            .CALL_a16 => Execution.call(cpu, 24),
            .ADC_A_n8 => Execution.adc_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .SBC_A_n8 => Execution.sbc_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .XOR_A_n8 => Execution.xor_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .CP_A_n8 => Execution.cp_r8_n8(cpu, &cpu.registers.r8.l.a, 8),
            .RST_1 => Execution.call_v16(cpu, 0x08, 16),
            .RST_3 => Execution.call_v16(cpu, 0x18, 16),
            .RST_5 => Execution.call_v16(cpu, 0x28, 16),
            .RST_7 => Execution.call_v16(cpu, 0x38, 16),
        }
    }

    pub fn executePrefixOPCode(cpu: *CPU, opcode: u8) void {
        const masked_b1_a = opcode & 0b1111_1000;
        const masked_b1_b = opcode & 0b1100_0000;

        if (masked_b1_a == 0b0000_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.rlc_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.rlc_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0000_1000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.rrc_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.rrc_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0001_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.rl_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.rl_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0001_1000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.rr_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.rr_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0010_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.sla_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.sla_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0010_1000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.sra_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.sra_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0011_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.swap_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.swap_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_a == 0b0011_1000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.srl_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 16); 
            } else { Execution.srl_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), 8); }
        } else if (masked_b1_b == 0b0100_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.bit_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 12);
            } else {
                Execution.bit_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 8);
            }
        } else if (masked_b1_b == 0b1000_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.res_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 16);
            } else {
                Execution.res_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 8);
            }
        } else if (masked_b1_b == 0b1100_0000) {
            if (decode_r8_enum(read_bits_from_byte(u3, opcode, 0)) == r8e.HL) {
                Execution.set_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 16);
            } else {
                Execution.set_b3_r8(cpu, decode_r8(read_bits_from_byte(u3, opcode, 0)), read_bits_from_byte(u3, opcode, 3), 8);
            }
        }
    }

    fn decode_r8(cpu: *CPU, r8: u3) *u8 {
        return switch (r8) {
            0 => &cpu.registers.r8.l.b,
            1 => &cpu.registers.r8.l.c,
            2 => &cpu.registers.r8.l.d,
            3 => &cpu.registers.r8.l.e,
            4 => &cpu.registers.r8.l.h,
            5 => &cpu.registers.r8.l.l,
            6 => cpu.bus.pointer(cpu.registers.r16.hl),
            7 => &cpu.registers.r8.l.a,
        };
    }

    const r8e = enum {
        B,
        C,
        D,
        E,
        H,
        L,
        HL,
        A
    };

    fn decode_r8_enum(r8: u3) r8e {
        return switch (r8) {
            0 => r8e.B,
            1 => r8e.C,
            2 => r8e.D,
            3 => r8e.E,
            4 => r8e.H,
            5 => r8e.L,
            6 => r8e.HL,
            7 => r8e.A,
        };
    }

    // Read sub-u8 type from u8 value and bit offset
    fn read_bits_from_byte(comptime T: type, op_byte: u8, bit_offset: usize) T {
        const src_type_bit_size = @bitSizeOf(@TypeOf(op_byte));
        const dst_type_bit_size = @bitSizeOf(T);
        assert(bit_offset + dst_type_bit_size <= src_type_bit_size);

        return @truncate(op_byte >> @intCast(bit_offset));
    }

    pub fn assert(ok: bool) void {
        if (!ok) unreachable; // assertion failure
    }

    pub const Instruction = enum(u8) {
        //0-40
        NOP = 0x00,
        STOP_n8 = 0x10,
        // jumps
        JR_NZ_e8 = 0x20,
        JR_NC_e8 = 0x30,
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