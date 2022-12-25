const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const debug = b.addExecutable("debug", "src/main.zig");
    debug.setOutputDir("build");
    
    const debug_step = b.step("debug", "Compile debug build");
    debug_step.dependOn(&debug.step);

    const run_step = b.step("run", "Run debug build");
    run_step.dependOn(&debug.run().step);
    
    const linux = b.addExecutable("linux", "src/main.zig");
    linux.setBuildMode(.ReleaseFast);
    linux.setOutputDir("build");

    const linux_step = b.step("linux", "Compile linux release build");
    linux_step.dependOn(&linux.step);

    const windows = b.addExecutable("windows.exe", "src/main.zig");
    windows.setBuildMode(.ReleaseFast);
    windows.setOutputDir("build");

    const windows_step = b.step("windows", "Compile windows release build");
    windows_step.dependOn(&windows.step);

    // const test_step = b.step("test", "Run unit tests");
}
