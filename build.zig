const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const version = comptime try std.SemanticVersion.parse("0.9.1");
    const compatible = comptime @import("builtin").zig_version.order(version) == .eq;
    if (!compatible)
        @compileError("Supported only zig 0.9.1 version");

    const debug = b.addExecutable("debug", "src/main.zig");
    debug.setOutputDir("build");
    debug.addPackage(.{
        .name = "read",
        .path = .{ .path = "src/read.zig" },
    });
    debug.addPackage(.{
        .name = "write",
        .path = .{ .path = "src/write.zig" },
    });

    const debug_step = b.step("debug", "Compile debug build");
    debug_step.dependOn(&debug.step);

    const run_step = b.step("run", "Run debug build");
    run_step.dependOn(&debug.run().step);

    const linux = b.addExecutable("linux", "src/main.zig");
    linux.setBuildMode(.ReleaseFast);
    linux.setOutputDir("build");
    linux.addPackage(.{
        .name = "read",
        .path = .{ .path = "src/read.zig" },
    });
    linux.addPackage(.{
        .name = "write",
        .path = .{ .path = "src/write.zig" },
    });

    const linux_step = b.step("linux", "Compile linux release build");
    linux_step.dependOn(&linux.step);

    const windows = b.addExecutable("windows.exe", "src/main.zig");
    windows.setBuildMode(.ReleaseFast);
    windows.setOutputDir("build");
    windows.addPackage(.{
        .name = "read",
        .path = .{ .path = "src/read.zig" },
    });
    windows.addPackage(.{
        .name = "write",
        .path = .{ .path = "src/write.zig" },
    });

    const windows_step = b.step("windows", "Compile windows release build");
    windows_step.dependOn(&windows.step);

    const test_random = b.addTest("src/task/random.zig");
    const test_findmax = b.addTest("src/task/findmax.zig");
    const test_sortarr = b.addTest("src/task/sortarr.zig");

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&test_random.step);
    test_step.dependOn(&test_findmax.step);
    test_step.dependOn(&test_sortarr.step);
}
