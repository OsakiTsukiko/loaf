const std = @import("std");
const Registers = @import("./registers.zig").Registers;
const Interpretor = @import("./interpretor.zig").Interpretor;

pub const CPU = struct {
    registers: Registers,
    bus: MemoryBus = MemoryBus{},

    pub fn init() CPU {
        return CPU {
            .registers = Registers{
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
            }
        };
    }

    pub const MemoryBus = struct {
        memory: [0xFFFF]u8 = std.mem.zeroes([0xFFFF]u8),

        pub fn read_byte(self: *const MemoryBus, address: u16) u8 {
            return self.memory[@as(usize, @intCast(address))];
        }

        pub fn write_byte(self: *MemoryBus, address: u16, value: u8) void {
            self.memory[@as(usize, @intCast(address))] = value;
        }
    };
};