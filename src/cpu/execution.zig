const std = @import("std");
const CPU = @import("./cpu.zig").CPU;

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
};