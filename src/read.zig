const std = @import("std");
const stdin = std.io.getStdIn().reader();
const parseInt = std.fmt.parseInt;
var buf: [1024]u8 = undefined;

/// All possible tasks
pub const TaskId = enum {
    random,
    findmax,

    pub fn read() !TaskId {
        const line = try stdin.readUntilDelimiter(buf[0..], '\n');
        return switch (line[0]) {
            '0' => .random,
            '1' => .findmax,
            else => error.TaskIdReadError,
        };
    }
};

/// Read bool in one line
/// First non-zero symbol - true
pub fn readBool() !bool {
    const line = try stdin.readUntilDelimiter(buf[0..], '\n');
    return line[0] != '0';
}

/// Read integer in one line
pub fn readInt(comptime T: type) !T {
    return try parseInt(T, try stdin.readUntilDelimiter(buf[0..], '\n'), 10);
}
