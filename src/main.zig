const std = @import("std");
const rand = @import("task/random.zig").rand;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    try rand(allocator, true);
}