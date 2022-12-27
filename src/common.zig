const std = @import("std");
const reader = @import("reader");

/// Custom slice printing for task format
pub fn printSlice(comptime T: type, slice: []const T) !void {
    if (@typeInfo(T) != .Int)
        @compileError("printSlice defined for integer types only");
    
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{d}", .{slice[0]});
    for (slice[1..]) |item| {
        try stdout.print(" {d}", .{item});
    }
    try stdout.writeAll("\n");
}

/// Task invoking tool
pub const TaskId = enum {
    findmax,
    sortarr,
    sortll,

    pub fn fromIO() !TaskId {
        const id = try reader.stdin.readByte();
        _ = try reader.stdin.readByte();
        const subid = try reader.stdin.readByte();
        
        return switch (id) {
            '1' => if (subid == '1') .findmax else .sortarr,
            '2' => .sortll,
            else => error.UnrecognizedTaskId,
        };
    }

    pub fn eval(self: TaskId, allocator: std.mem.Allocator, out: bool) !void {
        return switch (self) {
            .findmax => @import("findmax.zig").run(allocator, out),
            .sortarr => @import("sortarr.zig").run(allocator, out),
            .sortll => @import("sortll.zig").run(allocator, out),
        };
    }
};