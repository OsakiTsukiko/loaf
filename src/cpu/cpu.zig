const std = @import("std");
const Registers = @import("./registers.zig").Registers;
const Interpretor = @import("./interpretor.zig").Interpretor;

pub const CPU = struct {
    registers: Registers = Registers{
        .r8 = .{ .l = .{
            .b = 0x00,
            .c = 0x00,
            .d = 0x00,
            .e = 0x00,
            .h = 0x00,
            .l = 0x00,
            .flags = .{
                .zero = false,
                .substract = false,
                .half_carry = 0,
                .carry = 0,
            },
            .a = 0x00,
            .sp = 0x0000,
            .pc = 0x0000,
        } }
    },
    bus: MemoryBus = MemoryBus{},

    enable_interrupts_master: bool = false,
    is_halted: bool = false,
    
    
    
    pub fn nextOPCode(self: *CPU) u8 {
        const res = self.bus.read_byte(self.registers.r16.pc);
        self.registers.r16.pc = @addWithOverflow(self.registers.r16.pc, 1)[1]; // TOOD: USE INCREMENT?
        return res;
    }

    pub fn next2OPCode(self: *CPU) u16 {
        const l = self.nextOPCode();
        const h = self.nextOPCode();

        return @as(u16, l) | (@as(u16, @intCast(h)) << 8);
    }

    pub fn waitCycles(self: *CPU, cycles: u8) void {
        _ = self;
        _ = cycles;
    }



    pub const MemoryBus = struct {
        memory: [0xFFFF]u8 = std.mem.zeroes([0xFFFF]u8),

        pub fn read_byte(self: *const MemoryBus, address: u16) u8 {
            return self.memory[@as(usize, @intCast(address))];
        }

        pub fn write_byte(self: *MemoryBus, address: u16, value: u8) void {
            self.memory[@as(usize, @intCast(address))] = value;
        }

        pub fn read_word(self: *const MemoryBus, address: u16) u16 {
            const l = self.read_byte(address);
            const h = self.read_byte(address + 1);

            return @as(u16, l) | (@as(u16, @intCast(h)) << 8);
        }

        pub fn write_word(self: *MemoryBus, address: u16, value: u16) void {
            self.write_byte(address, @truncate(value));
            self.write_byte(address + 1, @truncate(value >> 8));
        }

        pub fn pointer(self: *MemoryBus, address: u16) *u8 {
            return &self.memory[@as(usize, @intCast(address))];
        }
    };
};