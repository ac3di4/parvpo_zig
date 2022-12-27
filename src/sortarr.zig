const std = @import("std");
const log = std.log.debug;

const read = @import("reader").read;
const random = @import("random");
const printSlice = @import("common.zig").printSlice;

/// Program interface for sorting array
/// Read array size and generate it from seed
/// Then sort out array
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try read(usize);

    log("enter seed", .{});
    random.seed = try read(u32);

    const slice = try allocator.alloc(u32, n);
    random.fillSlice(slice);

    var timer = try std.time.Timer.start();
    try merge_sort(allocator, slice);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try printSlice(u32, slice);
}

/// Merge sort interface
pub fn merge_sort(allocator: std.mem.Allocator, data: []u32) !void {
    var tmp = try allocator.alloc(u32, data.len);
    std.mem.copy(u32, tmp, data);
    msort(data, tmp);
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

test "sortarr" {
    var data_ = [_]u32{1, 8, 3, 5, 1};
    const data: []u32 = data_[0..];

    merge_sort(std.testing.allocator, data);

    var res = [_]u32{1, 1, 3, 5, 8};
    try std.testing.expectEqualSlices(res, data);
}
