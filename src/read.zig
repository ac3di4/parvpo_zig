const std = @import("std");
const stdin = std.io.getStdIn().reader();
const parseInt = std.fmt.parseInt;
var buf: [1024]u8 = undefined;

/// All possible tasks
pub const TaskId = enum {
    random,
    findmax,
    sortarr,

    pub fn read() !TaskId {
        const line = try stdin.readUntilDelimiter(buf[0..], '\n');
        return switch (line[0]) {
            '0' => TaskId.random,
            '1' => {
                return switch (line[2]) {
                    '1' => TaskId.findmax,
                    '2' => TaskId.sortarr,
                    else => error.ReadTaskIdError,
                };
            },
            else => error.ReadTaskIdError
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
