const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const version = comptime try std.SemanticVersion.parse("0.10.0");
    const compatible = comptime @import("builtin").zig_version.order(version) == .eq;
    if (!compatible)
        @compileError("Supported only zig 0.10.0 version");

    const exe_name = if (b.option([]const u8, "exe", "Executable name")) |name| name else "main";

    const exe = b.addExecutable(exe_name, "src/main.zig");
    exe.setTarget(b.standardTargetOptions(.{}));
    exe.setBuildMode(b.standardReleaseOptions());
    exe.addPackagePath("reader", "lib/reader.zig");
    exe.addPackagePath("random", "lib/random.zig");
    exe.addPackagePath("llist", "lib/llist.zig");
    exe.strip = b.option(bool, "strip", "Strip executable");
    exe.single_threaded = true;
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&b.addTest("lib/random.zig").step);
    test_step.dependOn(&b.addTest("lib/llist.zig").step);
    test_step.dependOn(&b.addTest("src/findmax.zig").step);
    
    const sortll_test = b.addTest("src/sortll.zig");
    sortll_test.addPackagePath("llist", "lib/llist.zig");
    test_step.dependOn(&sortll_test.step);
}
