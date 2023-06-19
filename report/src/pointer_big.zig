const std = @import("std");

const RUNS = 1000;

const Params = struct {
    n1: i32,
    n2: u32,
    n3: i32,
    n4: f32,
    n5: i64,
    n6: f32,
    n7: i32,
    n8: f32,
    n9: i16,
    n10: i32,
    n11: i64,
    n12: u32,
    n13: i32,
    n14: f64,
    n15: i32,
    n16: u32,
};

fn function1(p: Params) Params {
    var q: Params = p;
    q.n14 = q.n8 + 4;
    return q;
}

fn function2(p: *Params) void {
    p.n14 = p.n8 + 4;
}

pub fn main() !void {
    var sum: u64 = 0;
    for (0 .. RUNS) |_| {
        var timer = try std.time.Timer.start();
        
        var p: Params = undefined;
        p = std.mem.zeroInit(Params, p);
        
        // p = function1(p);
        function2(&p);
        
        sum += timer.read() / std.time.ns_per_ms;
    }
    std.debug.print("{d}\n", .{sum / RUNS});
}
