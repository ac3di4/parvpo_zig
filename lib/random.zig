//! Realization of Linear congruential generator (LGC)
//! Written for u32
//! There is no multiplication with mod for zig (and I'm not going to write one)
//! So there are some magic casts

const std = @import("std");

const LList = @import("llist.zig").LList;

/// LCG constants
const m: u64 = 2147483648;
const a: u64 = 1103515245;
const c: u64 = 12345;

pub var seed: u32 = undefined;

fn lgc() callconv(.Inline) u32 {
    seed = @intCast(u32, (a * seed + c) % m);
    return seed;
}

/// Fill u32 slice with random values
pub fn fillSlice(slice: []u32) callconv(.Inline) void {
    for (slice) |*item| {
        item.* = lgc();
    }
}

/// Generate random
pub fn randLL(allocator: std.mem.Allocator, n: usize) !*LList(u32) {
    var list = try allocator.create(LList(u32));
    list.value = lgc();

    var i: usize = 1;
    var last = list;
    while (i < n) : (i += 1) {
        last.next = try allocator.create(LList(u32));
        last = last.next.?;
        last.value = lgc();
    }
    
    last.next = null;
    return list;
}

test "fillSlice" {
    const allocator = std.testing.allocator;
    var data = try allocator.alloc(u32, 10);
    defer allocator.free(data);

    seed = 7;
    fillSlice(data);

    const expected = [10]u32{1282168116, 642666333, 712265938, 1486001571, 2131988640, 220562521, 2099423262, 2083449087, 523310796, 715197717};
    try std.testing.expectEqualSlices(u32, expected[0..], data);
}