//! Linear congruential generator (LGC)
//! Works only for u32
//! Important: One should set seed before using
//! 
//! Also there is no optimized modular multiplication in zig (and I'm not writing one yet)
//! So there are some casts

const std = @import("std");

/// LCG constants
const m: u64 = 2147483648;
const a: u64 = 1103515245;
const c: u64 = 12345;

pub var seed: u32 = undefined;

pub fn rand() callconv(.Inline) u32 {
    seed = @intCast(u32, (a * seed + c) % m);
    return seed;
}

test "test random" {
    seed = 7;
    std.testing.expectEqual(1282168116, rand());
}
