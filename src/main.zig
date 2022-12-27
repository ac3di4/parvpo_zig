const std = @import("std");
const log = std.log.debug;

const reader = @import("reader");
const TaskId = @import("common.zig").TaskId;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    reader.init();

    log("enter task id", .{});
    const tid = try reader.read(TaskId);
    _ = try reader.stdin.readByte();

    log("enter output flag", .{});
    const out = try reader.read(bool);
    _ = try reader.stdin.readByte();

    try tid.eval(allocator, out);
}
