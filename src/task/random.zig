const std = @import("std");
const readInt = @import("read").readInt;
const log = std.log.debug;
const LList = @import("llist.zig").LList;

/// LCG constants
const m: u64 = 2147483648;
const a: u64 = 1103515245;
const c: u64 = 12345;

/// Linear congruential generator (LGC)
/// Written for u32
inline fn lgc(seed: *u32, data: []u32) void {
    for (data) |*item| {
        item.* = @intCast(u32, (a * seed.* + c) % m);
        seed.* = item.*;
    }
}

/// Generate random slice (for other tasks)
pub fn randSlice(allocator: std.mem.Allocator, seed: u32, n: usize) ![]u32 {
    var data = try allocator.alloc(u32, n);
    var seed_ = seed;
    lgc(&seed_, data);
    return data;
}

/// Generate random linked list (for other tasks)
pub fn randLL(allocator: std.mem.Allocator, seed: u32, n: usize) !*LList {
    var seed_ = seed;
    var list = try LList.init(allocator);
    
    // REALLY BAD DECISION (running out of time)
    var buf = try allocator.alloc(u32, 1);

    buf[0] = list.item;
    lgc(&seed_, buf);
    list.item = buf[0];
    
    var i: usize = 1;
    var last: *LList = list;
    while (i < n) : (i += 1) {
        last = try last.chain(allocator);
        buf[0] = last.item;
        lgc(&seed_, buf);
        last.item = buf[0];
    }

    return list;
}

/// Program interface for LCG
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter seed", .{});
    var seed = try readInt(u32);

    log("enter n", .{});
    const n = try readInt(usize);

    var data = try allocator.alloc(u32, n);

    var timer = try std.time.Timer.start();
    lgc(&seed, data);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{any}\n", .{data});
}

test "random" {
    const allocator = std.testing.allocator;
    var data = try allocator.alloc(u32, 10);
    defer allocator.free(data);

    var seed: u32 = 7;
    lgc(&seed, data);

    const precalc = [_]u32{ 1282168116, 642666333, 712265938, 1486001571, 2131988640, 220562521, 2099423262, 2083449087, 523310796, 715197717 };
    for (precalc) |val, i| {
        try std.testing.expectEqual(val, data[i]);
    }
}
