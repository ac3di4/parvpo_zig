const std = @import("std");

fn function(b: usize) callconv(.Inline) usize {
    return b + 1;
}

fn num() callconv(.Inline) usize {
    return 1000000000;
}

pub fn main() !void {
    var a: usize = 0;
    // var l = 1000000000;
    comptime var l = num();
    for (0 .. l) |b|
        a = function(b);
    std.debug.print("{}\n", .{a});
}