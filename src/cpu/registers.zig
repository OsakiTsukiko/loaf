const std = @import("std");

pub const Registers = packed union {
    r8: packed union {
        l: R8LE,
        b: R8BE, 
    },
    r16: R16,

    pub const R8LE = packed struct {
        c: u8,
        b: u8,
        e: u8,
        d: u8,
        l: u8,
        h: u8,
        flags: FlagRegister,
        a: u8, // accumulator 
        sp: u16, // stack pointer
        pc: u16, // program counter
    };

    pub const R8BE = packed struct {
        b: u8,
        c: u8,
        d: u8,
        e: u8,
        h: u8,
        l: u8,
        a: u8, // accumulator 
        flags: FlagRegister,
        sp: u16, // stack pointer
        pc: u16, // program counter
    };

    pub const R16 = packed struct {
        bc: u16,
        de: u16,
        hl: u16,
        af: u16,
        sp: u16, // stack pointer
        pc: u16, // program counter
    };

    pub const FlagRegister = packed struct {
        // flag register bits
        // ZNHC0000
        // Z: zero
        // N: subtraction
        // H: half carry
        // C: carry
        
        _padding: u4 = 0,
        carry: u1,
        half_carry: u1,
        substract: bool,
        zero: bool,
    };
};