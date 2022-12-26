const std = @import("std");
const readInt = @import("read").readInt;
const randLL = @import("random.zig").randLL;
const printLL = @import("write").printLL;
const LList = @import("llist.zig").LList;
const log = std.log.debug;

fn msort(p: *LList, n: usize) ?*LList {
    if (n == 1) {
        p.next = null;
        return p;
    }

    const mid: usize = n / 2;

    var p2 = p.next;
    var i: usize = 1;
    while (i < mid) : (i += 1) p2 = p2.?.next;

    var p1 = msort(p, mid);
    p2 = msort(p2.?, n - mid);

    var result: ?*LList = null;
    var last: ?*LList = null;
    if (p1.?.item < p2.?.item) {
        result = p1;
        last = p1;
        p1 = p1.?.next;
    } else {
        result = p2;
        last = p2;
        p2 = p2.?.next;
    }

    while (p1 != null and p2 != null) : (last = last.?.next) {
        if (p1.?.item < p2.?.item) {
            last.?.next = p1;
            p1 = p1.?.next;
        } else {
            last.?.next = p2;
            p2 = p2.?.next;
        }
    }

    if (p1) |_| {
        last.?.next = p1;
    }

    if (p2) |_| {
        last.?.next = p2;
    }

    return result;
}

/// Program interface for sorting linked list
/// Read array size and generate it from seed
/// Then sort out linked list
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try readInt(usize);

    log("enter seed", .{});
    const seed = try readInt(u32);

    var list = try randLL(allocator, seed, n);
    // log("generated {any}", .{slice});

    var timer = try std.time.Timer.start();
    list = msort(list, n).?;
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try printLL(list);
}

// test "sortarr" {
//     var data_ = [_]u32{1, 8, 3, 5, 1};
//     var data: []u32 = data_[0..];

//     const allocator = std.testing.allocator;
//     var tmp = try allocator.alloc(u32, data.len);
//     defer allocator.free(tmp);
//     msort_(data, tmp);

//     var res = [_]u32{1, 1, 3, 5, 8};
//     for (res) |item, i| {
//         try std.testing.expectEqual(item, data[i]);
//     }
// }
