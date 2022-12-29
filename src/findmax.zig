const std = @import("std");
const log = std.log.debug;

const random = @import("random.zig");
const common = @import("common.zig");

pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try common.readUInt(usize);

    log("enter seed", .{});
    random.seed = try common.readUInt(u32);

    const slice = try allocator.alloc(u32, n);
    defer allocator.free(slice);
    for (slice) |*item|
        item.* = random.rand();

    // Finally measure the time
    var timer = try std.time.Timer.start();
    var max = slice[0];
    for (slice[1..]) |item|
        max = @max(max, item);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{}\n", .{max});
}
