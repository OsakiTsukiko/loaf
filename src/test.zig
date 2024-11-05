const std = @import("std");
const testing = std.testing;

const CPU = @import("./cpu/cpu.zig").CPU;
const Registers = @import("./cpu/registers.zig").Registers;
const Interpretor = @import("./cpu/interpretor.zig").Interpretor;

test Registers {
    const r1 = Registers{.r8 = .{ .l = .{
        .b = 0x11,
        .c = 0x22,
        .d = 0x33,
        .e = 0x44,
        .h = 0x55,
        .l = 0x66,
        .flags = .{
            .zero = false,
            .substract = false,
            .carry = 1,
            .half_carry = 1,
        },
        .a = 0xFF,
        .sp = 0x8899,
        .pc = 0xAABB,
    }}};

    try testing.expect(r1.r8.b.b == 0x22 and r1.r8.b.c == 0x11);
    try testing.expect(r1.r8.b.d == 0x44 and r1.r8.b.e == 0x33);
    try testing.expect(r1.r8.b.h == 0x66 and r1.r8.b.l == 0x55);

    try testing.expect(r1.r16.bc == 0x1122);
    try testing.expect(r1.r16.de == 0x3344);
    try testing.expect(r1.r16.hl == 0x5566);
    try testing.expect(r1.r16.af == 0b11111111_0011_0000);
}