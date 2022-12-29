const std = @import("std");

pub fn readUInt(comptime T: type) !T {
    if (@typeInfo(T) != .Int or @typeInfo(T).Int.signedness == .signed)
        @compileError("readUint called with '" ++ @typeName(T) ++ "' instead of UInt type");
    
    const stdin = std.io.getStdIn().reader();
    var buf: [1024]u8 = undefined;
    var i: usize = 0;
    
    while (i < buf.len) : (i += 1) {
        if (stdin.readByte()) |byte| {
            buf[i] = byte;
            if (byte < '0' or byte > '9')
                return std.fmt.parseInt(T, buf[0..i], 10);
        } else |err| {
            if (i != 0)
                return std.fmt.parseInt(T, buf[0..i], 10);
            return err;
        }
    }
    return error.IntTooBig;
}


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
