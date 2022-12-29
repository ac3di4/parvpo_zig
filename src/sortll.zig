const std = @import("std");
const log = std.log.debug;

const random = @import("random.zig");
const readUInt = @import("common.zig").readUInt;

const Node = struct {
    value: u32,
    next: ?*Node,

    pub fn rand(allocator: std.mem.Allocator, n: usize) !*Node {
        if (n == 0)
            return error.ZeroLList;

        const head = try allocator.create(Node);
        head.value = random.rand();

        var tail = head;
        var i: usize = 1;

        while (i < n) : (i += 1) {
            tail.next = try allocator.create(Node);
            tail = tail.next.?;
            tail.value = random.rand();
        }

        tail.next = null;
        return head;
    }

    /// Custom format printing
    pub fn format(self: Node, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
        try writer.print("{d}", .{self.value});
        var tail = self.next;
        while (tail) |node| {
            try writer.print(" {d}", .{node.value});
            tail = node.next;
        }
    }

    pub fn deinit(self: *Node, allocator: std.mem.Allocator) void {
        var tail: ?*Node = self;
        while (tail) |node| {
            tail = node.next;
            allocator.destroy(node);
        }
    }
};

pub fn msort(list: *Node, n: usize) *Node {
    if (n == 1) return list;

    // find middle
    const mid: usize = n / 2;
    var premid: ?*Node = list;
    var i: usize = 1;
    
    while (i < mid) : (i += 1) {
        premid = premid.?.next;
    }
    
    // split in the middle
    var right = premid.?.next;
    premid.?.next = null;
    
    // call msort on halves
    var left: ?*Node = msort(list, mid);
    right = msort(right.?, n - mid);

    // choose head element
    var head = left.?;
    if (left.?.value < right.?.value)
        left = left.?.next
    else {
        head = right.?;
        right = right.?.next;
    }
    var tail = head;

    // drain elements
    while (left != null and right != null) : (tail = tail.next.? ) {
        if (left.?.value < right.?.value) {
            tail.next = left;
            left = left.?.next;
        } else {
            tail.next = right;
            right = right.?.next;
        }
    }

    if (left) |_| tail.next = left;
    if (right) |_| tail.next = right;

    return head;
}

pub fn run(allocator: std.mem.Allocator, out: bool) !void {
    log("enter n", .{});
    const n = try readUInt(usize);

    log("enter seed", .{});
    random.seed = try readUInt(u32);

    var list = try Node.rand(allocator, n);
    defer list.deinit(allocator);

    var timer = try std.time.Timer.start();
    list = msort(list, n);
    const estimated = timer.read() / std.time.ns_per_ms;

    const stdout = std.io.getStdOut().writer();
    try stdout.print("time: {d} ms\n", .{estimated});
    if (out) try stdout.print("{}\n", .{list});
}
