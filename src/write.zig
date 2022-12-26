const std = @import("std");
const stdout = std.io.getStdOut().writer();

/// Print u32 slice
pub fn printSlice(slice: []u32) !void {
    try stdout.print("{}", .{slice[0]});
    for (slice[1..]) |item| {
        try stdout.print(" {}", .{item});
    }
    try stdout.print("\n", .{});
}