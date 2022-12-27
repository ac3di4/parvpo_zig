const std = @import("std");
const log = std.log.debug;

const read = @import("reader").read;
const random = @import("random");

/// Find maximal element
fn findMax(data: []u32) callconv(.Inline) u32 {
    var max = data[0];
    for (data[1..]) |item|
        max = @max(max, item);
    return max;
}

/// Program interface for searching max
/// Read array size and generate it from seed
/// Then find max there
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try read(usize);

    log("enter seed", .{});
    random.seed = try read(u32);

    const slice = try allocator.alloc(u32, n);
    defer allocator.free(slice);
    random.fillSlice(slice);

    var timer = try std.time.Timer.start();
    var max = findMax(slice);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{}\n", .{max});
}

test "findmax" {
    var data_ = [_]u32{ 3, 1, 5, 7, 9 };
    const data: []u32 = data_[0..];

    try std.testing.expectEqual(findMax(data), 9);
}
