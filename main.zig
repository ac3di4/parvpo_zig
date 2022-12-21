const std = @import("std");

test "sample test" {
    try std.testing.expectEqual(10, 3 + 7);
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"zig"});
}
