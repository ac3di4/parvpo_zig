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

    var timer = try std.time.Timer.start();
    var tmp = try allocator.alloc(u32, slice.len);
    msort(slice, tmp);
    allocator.free(tmp); // free in measures included
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try common.printSlice(u32, slice);
}

/// Actual merge sort
fn msort(data: []u32, tmp: []u32) void {
    if (data.len == 1) return;

    const mid: usize = data.len / 2;
    msort(data[0..mid], tmp[0..mid]);
    msort(data[mid..], tmp[mid..]);

    // merge
    var i: usize = 0;
    var j: usize = mid;
    var k: usize = 0;
    while (i < mid and j < data.len) : (k += 1) {
        if (data[i] < data[j]) {
            tmp[k] = data[i];
            i += 1;
        } else {
            tmp[k] = data[j];
            j += 1;
        }
    }

    for (data[i..mid]) |item| {
        tmp[k] = item;
        k += 1;
    }

    for (data[j..]) |item| {
        tmp[k] = item;
        k += 1;
    }

    std.mem.copy(u32, data, tmp);
}
