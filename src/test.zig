const std = @import("std");
const testing = std.testing;

const Registers = @import("./cpu/registers.zig").Registers;

test "Registers" {
    var r1 = Registers{
        .b = 0x11,
        .c = 0x22,
        .d = 0x33,
        .e = 0x44,
        .h = 0x55,
        .l = 0x66,
        .a = 0x77,
        .f = 0x88,
        .sp = 0xABAB,
        .pc = 0xCDCD,
    };

    try testing.expect(r1.getBC() == 0x1122);
    try testing.expect(r1.getDE() == 0x3344);
    try testing.expect(r1.getHL() == 0x5566);
    try testing.expect(r1.getAF() == 0x7788);

    r1.f = 0b11110000;
    try testing.expect(r1.getFlagZ());
    try testing.expect(r1.getFlagN());
    try testing.expect(r1.getFlagH());
    try testing.expect(r1.getFlagC());
    r1.setFlagZ(false);
    r1.setFlagN(false);
    r1.setFlagH(false);
    r1.setFlagC(false);
    try testing.expect(!r1.getFlagZ());
    try testing.expect(!r1.getFlagN());
    try testing.expect(!r1.getFlagH());
    try testing.expect(!r1.getFlagC());
}