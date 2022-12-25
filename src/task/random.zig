const std = @import("std");
const readInt = @import("read").readInt;
const log = std.log.debug;

/// LCG constants
const m = 2147483648;
const a = 1103515245;
const c = 12345;

/// Linear congruential generator (LGC)
inline fn lgc(seed: *i64, data: []i64) void {
    for (data) |*item| {
        item.* = @mod(a * seed.* + c, m);
        seed.* = item.*;
    }
}

/// Program interface for LCG
pub fn rand(allocator: std.mem.Allocator, out: bool) !void {
    log("enter seed", .{});
    var seed = try readInt(i64);

    log("enter n", .{});
    const n = try readInt(usize);

    var data = try allocator.alloc(i64, n);

    var timer = try std.time.Timer.start();
    lgc(&seed, data);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{any}\n", .{data});
}

test "random" {
    const allocator = std.testing.allocator;
    var data = try allocator.alloc(i64, 10);
    defer allocator.free(data);

    var seed: i64 = 7;
    lgc(&seed, data);

    const precalc = [_]i64{ 1282168116, 642666333, 712265938, 1486001571, 2131988640, 220562521, 2099423262, 2083449087, 523310796, 715197717 };
    for (precalc) |val, i| {
        try std.testing.expectEqual(val, data[i]);
    }
}
