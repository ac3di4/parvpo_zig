const std = @import("std");

const RUNS = 1000;

const Position = struct {
    x: i32,
    y: i32,
    z: i32
};

fn function1(p: Position) Position {
    return .{
        .x = p.x + 1,
        .y = p.y,
        .z = p.z
    };
}

fn function2(p: *Position) void {
    p.x += 1;
}

pub fn main() !void {
    var sum: u64 = 0;
    for (0 .. RUNS) |_| {
        var timer = try std.time.Timer.start();
        
        var p: Position = undefined;
        p = std.mem.zeroInit(Position, p);
        
        p = function1(p);
        // function2(&p);
        
        sum += timer.read() / std.time.ns_per_ms;
    }
    std.debug.print("{d}\n", .{sum / RUNS});
}