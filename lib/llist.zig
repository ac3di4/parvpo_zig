const std = @import("std");

/// Headless linked list
pub fn LList(comptime T: type) type {
    return struct {
        const Self = @This();

        value: T,
        next: ?*Self,

        pub fn fromSlice(allocator: std.mem.Allocator, slice: []T) !*Self {
            const llist = try allocator.create(Self);
            llist.value = slice[0];
            var last = llist;
            for (slice[1..]) |value| {
                last.next = try allocator.create(Self);
                last = last.next.?;
                last.value = value;
            }
            last.next = null;
            return llist;
        }

        pub fn nth(self: *Self, n: usize) *Self {
            if (n == 0) return self;

            var res = self.next;
            var i: usize = 1;
            while (i < n) : (i += 1) {
                if (res) |llist|
                    res = llist.next;
            }

            if (res) |llist|
                return llist
            else
                @panic("LList out of bounds not coded");
        }

        pub fn chain(self: *Self, other: *Self) *Self {
            var last = self;
            while (last.next) |next| last = next;
            last.next = other;
            return self;
        }

        fn mergeSorted(right: *Self, left: *Self) *Self {
            var head: *Self = undefined;

            if (left.value < right.value) {
                head = left;
                head.next = if (left.next == null)
                    right
                else
                    left.next.?.mergeSorted(right);
            } else {
                head = right;
                head.next = if (right.next == null)
                    left
                else
                    right.next.?.mergeSorted(left);
            }

            return head;
        }

        /// Sort LList with merge sort
        /// Return new head link
        pub fn msort(self: *Self, n: usize) *Self {
            if (n == 1)
                return self;
            
            // Find middle
            const mid: usize = n / 2;
            const node = self.nth(mid - 1);
            var right = node.next.?;
            node.next = null;

            var left: *Self = self.msort(mid);
            right = right.msort(n - mid);
            
            return mergeSorted(left, right);
        }

        /// Custom format printing for linked lists of u32
        pub fn format(self: Self, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) @TypeOf(writer).Error!void {
            if (@typeInfo(T) != .Int)
                @compileError("LList printing coded for integers only");
            
            try writer.print("{d}", .{self.value});
            
            var last: ?*Self = self.next;
            while (last) |llist| {
                try writer.print(" {d}", .{llist.value});
                last = llist.next;
            }
        }

        pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
            if (self.next) |next| next.deinit(allocator);
            allocator.destroy(self);
        }
    };
}

test "llist" {
    var data = [_]u32{1, 8, 3, 5, 1};
    
    const allocator = std.testing.allocator;
    var llist = try LList(u32).fromSlice(allocator, data[0..]);
    defer llist.deinit(allocator);

    const eq = std.testing.expectEqual;
    
    var p: ?*LList(u32) = llist;
    for (data) |value, i| {
        try eq(value, p.?.value);
        try eq(value, llist.nth(i).value);
        p = p.?.next;
    }

    var llist2 = try LList(u32).fromSlice(allocator, data[4..]);
    llist = llist.chain(llist2);
    var last = llist.nth(5);
    try eq(last.value, 1);
    try eq(last.next, null);
}
