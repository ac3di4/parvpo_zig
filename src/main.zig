const std = @import("std");
const readBool = @import("read").readBool;
const TaskId = @import("read").TaskId;
const log = std.log.debug;

const random = @import("task/random.zig");
const findmax = @import("task/findmax.zig");
const sortarr = @import("task/sortarr.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    log("enter task id", .{});
    const tid = try TaskId.read();

    log("enter output flag", .{});
    const out = try readBool();

    try switch (tid) {
        .random => random.run(allocator, out),
        .findmax => findmax.run(allocator, out),
        .sortarr => sortarr.run(allocator, out),
    };
}
