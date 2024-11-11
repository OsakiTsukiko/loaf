const std = @import("std");
const CPU = @import("./cpu.zig").CPU;

const LDH_OFFSET: u16 = 0xff00;

pub const Execution = struct {
    // ADD

    pub fn add_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        // Z 0 H C
        // 1 4
        cpu.waitCycles(cycles);

        const result, const carry = @addWithOverflow(dest.*, source.*);
        _, const half_carry = @addWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(source.*)));

        cpu.registers.r8.l.flags.zero = result == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.carry = carry;
        dest.* = result;
    }

    pub fn add_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        // Z 0 H C
        // 1 8
        cpu.waitCycles(cycles);

        const result, const carry = @addWithOverflow(dest.*, value);
        _, const half_carry = @addWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(value)));
        cpu.registers.r8.l.flags.zero = result == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.carry = carry;
        dest.* = result;
    }

    pub fn add_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        // Z 0 H C
        // 2 8
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        add_r8_v8(cpu, dest, value, 0);
    }

    pub fn add_r16_r16(cpu: *CPU, dest: *u16, source: *u16, cycles: u8) void {
        // - 0 H C
        // 1 8
        cpu.waitCycles(cycles);
       
        const result, const carry = @addWithOverflow(dest, source.*);
        _, const half_carry = @addWithOverflow(@as(u12, @truncate(dest.*)), @as(u12, @truncate(source.*)));
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.carry = carry;
        dest.* = result;
    }

    pub fn add_sp_e8(cpu: *CPU, cycles: u8) void {
        // 0 0 H C
        // 2 16
        cpu.waitCycles(cycles);


        cpu.registers.r8.l.flags.zero = false;
        cpu.registers.r8.l.flags.substract = false;

        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        _, cpu.registers.r8.l.flags.carry = @addWithOverflow(
            @as(u8, @truncate(cpu.registers.r16.sp)),
            offset_u8
        );

        _, cpu.registers.r8.l.flags.half_carry = @addWithOverflow(
            @as(u4, @trunc(cpu.registers.r16.sp)), 
            @as(u4, @intCast(offset_i8 & 0xf))
        );
        
        // NOTE: using two's-complement to ignore signedness
        cpu.registers.r16.sp +%= @as(u16, @bitCast(@as(i16, offset_i8)));
    }

    // ADC
    
    pub fn adc_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        // Z 0 H C
        // 1 4
        cpu.waitCycles(cycles);

        const result_with_carry, const carry_1 = @addWithOverflow(dest.*, cpu.registers.r8.l.flags.carry);
        const result, const carry_2 = @addWithOverflow(result_with_carry, source.*);

        const result_with_half_carry, const half_carry_1 = @addWithOverflow(@as(u4, @truncate(dest.*)), cpu.registers.r8.l.flags.carry);
        _, const half_carry_2 = @addWithOverflow(result_with_half_carry, @as(u4, @truncate(source.*)));

        cpu.registers.r8.l.flags.carry = carry_1 | carry_2;
        cpu.registers.r8.l.flags.half_carry = half_carry_1 | half_carry_2;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn adc_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        // Z 0 H C 
        // 1 4/8
        cpu.waitCycles(cycles);

        const result_with_carry, const carry_1 = @addWithOverflow(dest.*, cpu.registers.r8.l.flags.carry);
        const result, const carry_2 = @addWithOverflow(result_with_carry, value);

        const result_with_half_carry, const half_carry_1 = @addWithOverflow(@as(u4, @truncate(dest.*)), cpu.registers.r8.l.flags.carry);
        _, const half_carry_2 = @addWithOverflow(result_with_half_carry, @as(u4, @truncate(value)));

        cpu.registers.r8.l.flags.carry = carry_1 | carry_2;
        cpu.registers.r8.l.flags.half_carry = half_carry_1 | half_carry_2;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn adc_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        // Z 0 H C 
        // 2 8
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        add_r8_v8(cpu, dest, value, 0);
    }

    pub fn sub_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const result, const carry = @subWithOverflow(dest.*, source.*);
        _, const half_carry = @subWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(source.*)));

        cpu.registers.r8.l.flags.carry = carry;
        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn sub_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const result, const carry = @subWithOverflow(dest.*, value);
        _, const half_carry = @subWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(value)));

        cpu.registers.r8.l.flags.carry = carry;
        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn sub_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        sub_r8_v8(cpu, dest, value, 0);
    }

    pub fn sbc_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const result_with_carry, const carry_a = @subWithOverflow(dest.*, cpu.registers.r8.l.flags.carry);
        const result, const carry_b = @subWithOverflow(result_with_carry, source.*);

        const result_with_half_carry, const half_carry_a = @subWithOverflow(@as(u4, @truncate(dest.*)), cpu.registers.r8.l.flags.carry);
        _, const half_carry_b = @subWithOverflow(result_with_half_carry, @as(u4, @truncate(source.*)));

        cpu.registers.r8.l.flags.carry = carry_a | carry_b;
        cpu.registers.r8.l.flags.half_carry = half_carry_a | half_carry_b;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn sbc_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const result_with_carry, const carry_a = @subWithOverflow(dest.*, cpu.registers.r8.l.flags.carry);
        const result, const carry_b = @subWithOverflow(result_with_carry, value);

        const result_with_half_carry, const half_carry_a = @subWithOverflow(@as(u4, @truncate(dest.*)), cpu.registers.r8.l.flags.carry);
        _, const half_carry_b = @subWithOverflow(result_with_half_carry, @as(u4, @truncate(value)));

        cpu.registers.r8.l.flags.carry = carry_a | carry_b;
        cpu.registers.r8.l.flags.half_carry = half_carry_a | half_carry_b;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = result == 0;

        dest.* = result;
    }

    pub fn sbc_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        sbc_r8_v8(cpu, dest, value, 0);
    }

    pub fn and_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        dest.* &= source.*;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 1;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn and_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        dest.* &= value;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 1;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn and_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        and_r8_v8(cpu, dest, value, 0);
    }

    pub fn xor_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        dest.* ^= source.*;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn xor_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        dest.* ^= value;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn xor_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        xor_r8_v8(cpu, dest, value, 0);
    }

    pub fn or_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        dest.* |= source.*;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn or_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        dest.* |= value;

        cpu.registers.r8.l.flags.zero = dest.* == 0;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = 0;
    }

    pub fn or_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        or_r8_v8(cpu, dest, value, 0);
    }

    pub fn cp_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        _, cpu.registers.r8.l.flags.carry = @subWithOverflow(dest.*, source.*);
        _, cpu.registers.r8.l.flags.half_carry = @subWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(source.*)));

        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = dest.* == source.*;
    }

    pub fn cp_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        _, cpu.registers.r8.l.flags.carry = @subWithOverflow(dest.*, value);
        _, cpu.registers.r8.l.flags.half_carry = @subWithOverflow(@as(u4, @truncate(dest.*)), @as(u4, @truncate(value)));

        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = dest.* == value;
    }

    pub fn cp_r8_n8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.nextOPCode();
        cp_r8_v8(cpu, dest, value, 0);
    }

    pub fn inc_r8(cpu: *CPU, reg: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        _, const half_carry = @addWithOverflow(@as(u4, @truncate(reg.*)), 1);
        reg.* +%= 1;

        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.zero = reg.* == 0;
    }

    pub fn inc_r16(cpu: *CPU, reg: *u16, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        reg.* +%= 1;
    }

    pub fn inc_adr(cpu: *CPU, address: u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.bus.read_byte(address);

        _, const half_carry = @addWithOverflow(@as(u4, @truncate(value)), 1);
        value +%= 1;

        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.zero = value == 0;

        cpu.bus.write_byte(address, value);
    }

    pub fn dec_r8(cpu: *CPU, reg: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        _, const half_carry = @subWithOverflow(@as(u4, @truncate(reg.*)), 1);
        reg.* -%= 1;

        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = reg.* == 0;
    }

    pub fn dec_r16(cpu: *CPU, reg: *u16, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        reg.* -%= 1;
    }

    pub fn dec_adr(cpu: *CPU, address: u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        const value = cpu.bus.read_byte(address);

        _, const half_carry = @subWithOverflow(@as(u4, @truncate(value)), 1);
        value -%= 1;

        cpu.registers.r8.l.flags.half_carry = half_carry;
        cpu.registers.r8.l.flags.substract = true;
        cpu.registers.r8.l.flags.zero = value == 0;

        cpu.bus.write_byte(address, value);
    }

    pub fn ccf(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        cpu.registers.r8.l.flags.carry ^= 1;

        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.substract = false;
    } 

    pub fn scf(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        cpu.registers.r8.l.flags.carry = 1;

        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.substract = false;
    }

    pub fn rra(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const lsb_set = (cpu.registers.r8.l.a & 0x01) != 0;

        cpu.registers.r8.l.a = cpu.registers.r8.l.a >> 1 | (@as(u8, cpu.registers.r8.l.flags.carry) << 7);

        cpu.registers.r8.l.flags.zero = false;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = if (lsb_set) 1 else 0;
    }

    pub fn rla(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const msb_set = (cpu.registers.r8.l.a & 0x80) != 0;

        cpu.registers.r8.l.a = cpu.registers.r8.l.a << 1 | cpu.registers.r8.l.flags.carry;

        cpu.registers.r8.l.flags.zero = false;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = if (msb_set) 1 else 0;
    }

    pub fn rrca(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const lsb_set = (cpu.registers.r8.l.a & 0x01) != 0;

        cpu.registers.r8.l.a = std.math.rotr(u8, cpu.registers.r8.l.a, 1);

        cpu.registers.r8.l.flags.zero = false;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = if (lsb_set) 1 else 0;
    }

    pub fn rlca(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const msb_set = (cpu.registers.r8.l.a & 0x80) != 0;

        cpu.registers.r8.l.a = std.math.rotl(u8, cpu.registers.r8.l.a, 1);

        cpu.registers.r8.l.flags.zero = false;
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = if (msb_set) 1 else 0;
    }

    pub fn cpl(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        cpu.registers.r8.l.a ^= 0b1111_1111;

        cpu.registers.r8.l.flags.half_carry = 1;
        cpu.registers.r8.l.flags.substract = true;
    }

    pub fn daa(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        if (cpu.registers.r8.l.flags.substract) {
            if (cpu.registers.r8.l.flags.half_carry == 1) {
                cpu.registers.r8.l.a +%= 0xFA;
            }
            if (cpu.registers.r8.l.flags.carry == 1) {
                cpu.registers.r8.l.a +%= 0xA0;
            }
        } else {
            var a: i16 = cpu.registers.r8.l.a;
            if ((cpu.registers.r8.l.a & 0xF) > 0x9 or cpu.registers.r8.l.flags.half_carry == 1) {
                a += 0x6;
            }
            if ((a & 0x1F0) > 0x90 or cpu.registers.r8.l.flags.carry == 1) {
                a += 0x60;
                cpu.registers.r8.l.flags.carry = 1;
            } else {
                cpu.registers.r8.l.flags.carry = 0;
            }
            cpu.registers.r8.l.a = @intCast(a & 0xff);
        }

        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.zero = cpu.registers.r8.l.a == 0;
    }

    pub fn ld_r8_r8(cpu: *CPU, dest: *u8, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        dest.* = source.*;
    }

    pub fn ld_r8_v8(cpu: *CPU, dest: *u8, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        dest.* = value;
    }

    pub fn ld_adr_r8(cpu: *CPU, address: u16, source: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        cpu.bus.write_byte(address, source.*);
    }

    pub fn ld_adr_v8(cpu: *CPU, address: u16, value: u8, cycles: u8) void {
        cpu.waitCycles(cycles);
        cpu.bus.write_byte(address, value);
    }

    pub fn ld_r16_v16(cpu: *CPU, dest: *u16, value: u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        dest.* = value;
    }

    pub fn ld_adr_SP(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const adr = cpu.next2OPCode();

        const p = @as(u8, @truncate(cpu.registers.r16.sp));
        const s = @as(u8, @truncate(cpu.registers.r16.sp >> 8));

        cpu.bus.write_byte(adr, p);
        cpu.bus.write_byte(adr +% 1, s);
    }

    pub fn ldh_adr_n8_a(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        const address = cpu.nextOPCode();

        cpu.bus.write_byte(LDH_OFFSET + address, cpu.registers.r8.l.a);
    }

    pub fn ldh_a_adr_n8(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        const address = cpu.nextOPCode();

        cpu.registers.r8.l.a = cpu.bus.read_byte(LDH_OFFSET + address);
    }

    pub fn ld_c_a(cpu: *CPU, cycles: u8) void {
        // ld? ldh?
        cpu.waitCycles(cycles);
        cpu.bus.write_byte(LDH_OFFSET + cpu.registers.r8.l.c, cpu.registers.r8.l.a);
    }

    pub fn ld_a_c(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        // ld? ldh?
        cpu.registers.r8.l.a = cpu.bus.read_byte(LDH_OFFSET + cpu.registers.r8.l.c);
    }

    pub fn ld_hl_sp_n8(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));
        
        // NOTE: very tricky carry behavior
        _, cpu.registers.r8.l.flags.carry = @addWithOverflow(@as(u8, @truncate(cpu.registers.r16.sp)), offset_u8);
        _, cpu.registers.r8.l.flags.half_carry = @addWithOverflow(@as(u4, @truncate(cpu.registers.r16.sp)), @as(u4, @intCast(offset_i8 & 0xf)));
        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.zero = false;

        // NOTE: using two's-complement to ignore signedness
        cpu.registers.r16.hl = cpu.registers.r16.sp +% @as(u16, @bitCast(@as(i16, offset_i8)));
    }

    pub fn jr_n8(cpu: *CPU, _: u8) void {
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        cpu.waitCycles(12);
        cpu.registers.r16.pc +%= @as(u16, @bitCast(@as(i16, offset_i8)));
    }

    pub fn jr_nz_n8(cpu: *CPU, _: u8) void {
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        if (!cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(12);
            cpu.registers.r16.pc +%= @as(u16, @bitCast(@as(i16, offset_i8)));
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn jr_z_n8(cpu: *CPU, _: u8) void {
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        if (cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(12);
            cpu.registers.r16.pc +%= @as(u16, @bitCast(@as(i16, offset_i8)));
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn jr_nc_n8(cpu: *CPU, _: u8) void {
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        if (cpu.registers.r8.l.flags.carry == 0) {
            cpu.waitCycles(12);
            cpu.registers.r16.pc +%= @as(u16, @bitCast(@as(i16, offset_i8)));
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn jr_c_n8(cpu: *CPU, _: u8) void {
        const offset_u8 = cpu.nextOPCode();
        const offset_i8 = @as(i8, @bitCast(offset_u8));

        if (cpu.registers.r8.l.flags.carry == 1) {
            cpu.waitCycles(12);
            cpu.registers.r16.pc +%= @as(u16, @bitCast(@as(i16, offset_i8)));
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn jp_n16(cpu: *CPU, _: u8) void {
        cpu.waitCycles(16);
        cpu.registers.r16.pc = cpu.next2OPCode();
    }

    pub fn jp_nz_n16(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (!cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(16);
            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn jp_z_n16(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(16);
            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn jp_nc_n16(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (!cpu.registers.r8.l.flags.carry == 0) {
            cpu.waitCycles(16);
            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn jp_c_n16(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (cpu.registers.r8.l.flags.carry == 1) {
            cpu.waitCycles(16);
            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn jp_hl(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        cpu.registers.r16.pc = cpu.registers.r16.hl;
    }

    pub fn pop_r16(cpu: *CPU, dest: *u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        dest.* = cpu.bus.read_word(cpu.registers.r16.sp);
        cpu.registers.r16.sp +%= 2;
    }

    pub fn push_r16(cpu: *CPU, source: *u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        cpu.registers.r16.sp -%= 2;
        cpu.bus.write_word(cpu.registers.r16.sp, source.*);
    }

    pub fn ret(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        cpu.registers.r16.pc = cpu.bus.read_byte(cpu.registers.r16.sp);
        cpu.registers.r16.sp +%= 2;
    }

    pub fn ret_nz(cpu: *CPU, _: u8) void {
        if (!cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(20);
            cpu.registers.r16.pc = cpu.bus.read_byte(cpu.registers.r16.sp);
            cpu.registers.r16.sp +%= 2;
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn ret_z(cpu: *CPU, _: u8) void {
        if (cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(20);
            cpu.registers.r16.pc = cpu.bus.read_byte(cpu.registers.r16.sp);
            cpu.registers.r16.sp +%= 2;
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn ret_nc(cpu: *CPU, _: u8) void {
        if (cpu.registers.r8.l.flags.carry == 0) {
            cpu.waitCycles(20);
            cpu.registers.r16.pc = cpu.bus.read_byte(cpu.registers.r16.sp);
            cpu.registers.r16.sp +%= 2;
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn ret_c(cpu: *CPU, _: u8) void {
        if (cpu.registers.r8.l.flags.carry == 1) {
            cpu.waitCycles(20);
            cpu.registers.r16.pc = cpu.bus.read_byte(cpu.registers.r16.sp);
            cpu.registers.r16.sp +%= 2;
        } else {
            cpu.waitCycles(8);
        }
    }

    pub fn reti(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);
        ret(cpu, 0);
        cpu.enable_interrupts_master = true;
    }

    pub fn call(cpu: *CPU, cycles: u8) void {
        cpu.waitCycles(cycles);

        const address = cpu.next2OPCode();

        cpu.registers.r16.sp -%= 2;
        cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

        cpu.registers.r16.pc = address;
    }

    pub fn call_v16(cpu: *CPU, address: u16, cycles: u8) void {
        cpu.waitCycles(cycles);

        cpu.registers.r16.sp -%= 2;
        cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

        cpu.registers.r16.pc = address;
    }

    pub fn call_nz(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (!cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(24);
            cpu.registers.r16.sp -%= 2;
            cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn call_z(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (cpu.registers.r8.l.flags.zero) {
            cpu.waitCycles(24);
            cpu.registers.r16.sp -%= 2;
            cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn call_nc(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (cpu.registers.r8.l.flags.carry == 0) {
            cpu.waitCycles(24);
            cpu.registers.r16.sp -%= 2;
            cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    pub fn call_c(cpu: *CPU, _: u8) void {
        const address = cpu.next2OPCode();

        if (cpu.registers.r8.l.flags.carry == 1) {
            cpu.waitCycles(24);
            cpu.registers.r16.sp -%= 2;
            cpu.bus.write_word(cpu.registers.r16.sp, cpu.registers.r16.pc);

            cpu.registers.r16.pc = address;
        } else {
            cpu.waitCycles(12);
        }
    }

    // PREFIX

    pub fn rlc_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_msb_set = (r8_value & 0x80) != 0;

        const op_result = std.math.rotl(u8, r8_value, 1);

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_msb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn rrc_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_lsb_set = (r8_value & 0x01) != 0;

        const op_result = std.math.rotr(u8, r8_value, 1);

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_lsb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn rl_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_msb_set = (r8_value & 0x80) != 0;

        const op_result = r8_value << 1 | cpu.registers.r8.l.flags.carry;

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_msb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn rr_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_lsb_set = (r8_value & 0x01) != 0;

        const op_result = r8_value >> 1 | @as(u8, cpu.registers.r8.l.flags.carry) << 7;

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_lsb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn sla_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_msb_set = (r8_value & 0x80) != 0;
        const r8_rest_unset = (r8_value & 0x7F) == 0;

        const op_result = r8_value << 1;

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_msb_set;
        cpu.registers.r8.l.flags.zero = r8_rest_unset; // TODO: op_result == 0?
    }

    pub fn sra_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_msb = r8_value & 0x80;
        const r8_lsb_set = (r8_value & 0x01) != 0;

        const op_result = r8_value >> 1 | r8_msb;

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_lsb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn swap_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;

        const op_result = (r8_value << 4) | (r8_value >> 4);

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = 0;
        cpu.registers.r8.l.flags.zero = r8_value == 0;// TODO: op_result?
    }

    pub fn srl_r8(cpu: *CPU, dest: *u8, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;
        const r8_lsb_set = (r8_value & 0x01) != 0;

        const op_result = r8_value >> 1;

        dest.* = op_result;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 0;
        cpu.registers.r8.l.flags.carry = r8_lsb_set;
        cpu.registers.r8.l.flags.zero = op_result == 0;
    }

    pub fn bit_b3_r8(cpu: *CPU, dest: *u8, bit_index: u3, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;

        const bit = @as(u8, 1) << bit_index;
        const op_result = r8_value & bit;

        cpu.registers.r8.l.flags.substract = false;
        cpu.registers.r8.l.flags.half_carry = 1;
        cpu.registers.r8.l.flags.zero = op_result == 0; // OP_RESULT == 0 or just OP_RESULT
    }

    pub fn res_b3_r8(cpu: *CPU, dest: *u8, bit_index: u3, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;

        const bit = @as(u8, 1) << bit_index;
        const op_result = r8_value & ~bit;

        dest.* = op_result;
    }

    pub fn set_b3_r8(cpu: *CPU, dest: *u8, bit_index: u3, cycles: u8) void {
        cpu.waitCycles(cycles);

        const r8_value = dest.*;

        const bit = @as(u8, 1) << bit_index;
        const op_result = r8_value | bit;

        dest.* = op_result;
    }
};