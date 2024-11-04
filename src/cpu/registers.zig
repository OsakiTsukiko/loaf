const std = @import("std");

pub const Registers = struct {
    // 1 byte: b, c, d, e, h, l, a, f,
    // 2 byes: bc, de, hl, af,

    b: u8 = 0,
    c: u8 = 0,
    d: u8 = 0,
    e: u8 = 0,
    h: u8 = 0,
    l: u8 = 0,
    a: u8 = 0, // accumulator
    f: u8 = 0, // flag register
    sp: u16 = 0, // stack pointer
    pc: u16 = 0, // program counter

    // flag register bits
    // ZNHC0000
    // Z: zero
    // N: subtraction
    // H: half carry
    // C: carry

    pub fn getAF(self: *const Registers) u16 {
        const res: u16 = (@as(u16, @intCast(self.a)) << 8) | @as(u16, @intCast(self.f));
        return res; 
    }

    pub fn setAF(self: *Registers, value: u16) void {
        self.a = @as(u8, @intCast((value & 0xFF00) >> 8));
        self.f = @as(u8, @intCast(value & 0xFF));
    }

    pub fn getBC(self: *const Registers) u16 {
        const res: u16 = (@as(u16, @intCast(self.b)) << 8) | @as(u16, @intCast(self.c));
        return res; 
    }

    pub fn setBC(self: *Registers, value: u16) void {
        self.b = @as(u8, @intCast((value & 0xFF00) >> 8));
        self.c = @as(u8, @intCast(value & 0xFF));
    }

    pub fn getDE(self: *const Registers) u16 {
        const res: u16 = (@as(u16, @intCast(self.d)) << 8) | @as(u16, @intCast(self.e));
        return res; 
    }

    pub fn setDE(self: *Registers, value: u16) void {
        self.d = @as(u8, @intCast((value & 0xFF00) >> 8));
        self.e = @as(u8, @intCast(value & 0xFF));
    }

    pub fn getHL(self: *const Registers) u16 {
        const res: u16 = (@as(u16, @intCast(self.h)) << 8) | @as(u16, @intCast(self.l));
        return res; 
    }

    pub fn setHL(self: *Registers, value: u16) void {
        self.h = @as(u8, @intCast((value & 0xFF00) >> 8));
        self.l = @as(u8, @intCast(value & 0xFF));
    }

    pub fn getFlagZ(self: *const Registers) bool {
        return ((self.f & 0b10000000) >> 7) == 1;
    }

    pub fn setFlagZ(self: *Registers, value: bool) void {
        if (value) {
            self.f |= 0b10000000;
        } else {
            self.f &= 0b01111111;
        }
    }

    pub fn getFlagN(self: *const Registers) bool {
        return ((self.f & 0b01000000) >> 6) == 1;
    }

    pub fn setFlagN(self: *Registers, value: bool) void {
        if (value) {
            self.f |= 0b01000000;
        } else {
            self.f &= 0b10111111;
        }
    }

    pub fn getFlagH(self: *const Registers) bool {
        return ((self.f & 0b00100000) >> 5) == 1;
    }

    pub fn getFlagHInt(self: *const Registers) u1 {
        return @as(u1, @intCast((self.f & 0b00100000) >> 5));
    }

    pub fn setFlagH(self: *Registers, value: bool) void {
        if (value) {
            self.f |= 0b00100000;
        } else {
            self.f &= 0b11011111;
        }
    }

    pub fn getFlagC(self: *const Registers) bool {
        return ((self.f & 0b00010000) >> 4) == 1;
    }

    pub fn getFlagCInt(self: *const Registers) u1 {
        return @as(u1, @intCast((self.f & 0b00010000) >> 4));
    }

    pub fn setFlagC(self: *Registers, value: bool) void {
        if (value) {
            self.f |= 0b00010000;
        } else {
            self.f &= 0b11101111;
        }
    }
};