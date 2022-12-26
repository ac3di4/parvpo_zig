const std = @import("std");
const readInt = @import("read").readInt;
const randSlice = @import("random.zig").randSlice;
const log = std.log.debug;

/// Actual merge sort
/// Uses only one additional chunk of memory (tmp)
fn msort_(data: []u32, tmp: []u32) void {
    if (data.len == 1) return;

    const mid: usize = data.len / 2;
    msort_(data[0..mid], tmp[0..mid]);
    msort_(data[mid..], tmp[mid..]);

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

/// Merge sort interface
/// CAN LEAK
pub fn msort(allocator: std.mem.Allocator, data: []u32) !void {
    var tmp = try allocator.alloc(u32, data.len);
    std.mem.copy(u32, tmp, data);
    msort_(data, tmp);
}

/// Program interface for sorting array
/// Read array size and generate it from seed
/// Then sort out array
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try readInt(usize);

    log("enter seed", .{});
    const seed = try readInt(u32);

    const slice = try randSlice(allocator, seed, n);
    log("generated {any}", .{slice});

    var timer = try std.time.Timer.start();
    try msort(allocator, slice);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{any}\n", .{slice});
}

test "sortarr" {
    var data_ = [_]u32{1, 8, 3, 5, 1};
    var data: []u32 = data_[0..];

    const allocator = std.testing.allocator;
    var tmp = try allocator.alloc(u32, data.len);
    defer allocator.free(tmp);
    msort_(data, tmp);

    var res = [_]u32{1, 1, 3, 5, 8};
    for (res) |item, i| {
        try std.testing.expectEqual(item, data[i]);
    }
}
