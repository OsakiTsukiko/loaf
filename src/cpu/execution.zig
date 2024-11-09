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
};