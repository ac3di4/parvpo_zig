const std = @import("std");
const readBool = @import("read").readBool;
const TaskId = @import("read").TaskId;
const log = std.log.debug;

const rand = @import("task/random.zig").rand;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    log("enter task id", .{});
    const tid = try TaskId.read();

    log("enter output flag", .{});
    const out = try readBool();

    try switch (tid) {
        .random => rand(allocator, out),
    };
}
