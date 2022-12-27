const std = @import("std");
const log = std.log.debug;

const read = @import("reader").read;
const random = @import("random");
const LList = @import("llist").LList;

/// Program interface for sorting linked list
/// Read array size and generate it from seed
/// Then sort out linked list
pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try read(usize);

    log("enter seed", .{});
    random.seed = try read(u32);

    var llist = try random.randLL(allocator, n);
    defer llist.deinit(allocator);

    var timer = try std.time.Timer.start();
    llist = llist.msort(n);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{}\n", .{llist});
}

test "sortll" {
    var data_ = [_]u32{ 1, 8, 3, 5, 1 };
    var data: []u32 = data_[0..];

    const allocator = std.testing.allocator;
    var llist = try LList(u32).fromSlice(allocator, data);
    defer llist.deinit(allocator);

    llist = llist.msort(data.len);

    var res = [_]u32{1, 1, 3, 5, 8};
    const eq = std.testing.expectEqual;
    var p: ?*LList(u32) = llist;
    for (res) |item| {
        try eq(item, p.?.value);
        p = p.?.next;
    }
}
