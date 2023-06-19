const std = @import("std");

const RUNS = 10;
const CALLCONV = std.builtin.CallingConvention.Inline;

fn function(b: usize) callconv(CALLCONV) usize {
    return b + 1;
}

pub fn main() !void {
    var sum: u64 = 0;
    for (0 .. RUNS) |_| {
        var timer = try std.time.Timer.start();
        var a: usize = 0;
        for (0 .. 1000000000) |b|
            a = function(b);
        sum += timer.read() / std.time.ns_per_ms;
    }
    std.debug.print("{d}\n", .{sum / RUNS});
}
