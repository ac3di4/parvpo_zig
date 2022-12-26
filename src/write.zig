const std = @import("std");
const stdout = std.io.getStdOut().writer();
const LList = @import("task/llist.zig").LList;

/// Print u32 slice
pub fn printSlice(slice: []u32) !void {
    try stdout.print("{}", .{slice[0]});
    for (slice[1..]) |item| {
        try stdout.print(" {}", .{item});
    }
    try stdout.print("\n", .{});
}

pub fn printLL(list: *LList) !void {
    try stdout.print("{}", .{list.item});

    var last = list.next;
    while (last) |next| {
        try stdout.print(" {}", .{next.item});
        last = next.next;
    }
    try stdout.print("\n", .{});
}