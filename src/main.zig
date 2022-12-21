const std = @import("std");
const ProgId = @import("config.zig").ProgId;


pub fn main() !void {
    std.log.debug("This is a debug build", .{});

    const stdin = std.io.getStdIn().reader();
    var buf: [1024]u8 = undefined;

    std.log.debug("Enter program id", .{});

    var pid: ProgId = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        pid = try ProgId.fromBytes(input);
    } else {
        return error.NoProgramId;
    }

    std.log.debug("Enter output flag", .{});

    var output: bool = undefined;
    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        switch (input[0]) {
            '0' => output = false,
            '1' => output = true,
            else => return error.InvalidOutputFlag
        }
    } else {
        return error.NoOutputFlag;
    }

    std.debug.print("To be implemented\n", .{});
}