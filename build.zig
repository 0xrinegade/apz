const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Add modules
    const router_module = b.addModule("router", .{
        .source_file = .{ .path = "src/router.zig" },
    });

    const handlers_module = b.addModule("handlers", .{
        .source_file = .{ .path = "src/handlers.zig" },
        .dependencies = &.{
            .{ .name = "router", .module = router_module },
        },
    });

    const websocket_module = b.addModule("websocket", .{
        .source_file = .{ .path = "src/websocket.zig" },
        .dependencies = &.{
            .{ .name = "router", .module = router_module },
        },
    });

    // Main executable
    const exe = b.addExecutable(.{
        .name = "apz",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Add dependencies
    const spice_dep = b.dependency("spice", .{});
    exe.addModule("spice", spice_dep.module("spice"));
    exe.addModule("router", router_module);
    exe.addModule("handlers", handlers_module);
    exe.addModule("websocket", websocket_module);

    b.installArtifact(exe);

    // Run command
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the API server");
    run_step.dependOn(&run_cmd.step);

    // Tests
    const test_step = b.step("test", "Run tests");
    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    tests.addModule("spice", spice_dep.module("spice"));
    tests.addModule("router", router_module);
    tests.addModule("handlers", handlers_module);
    tests.addModule("websocket", websocket_module);

    const run_tests = b.addRunArtifact(tests);
    test_step.dependOn(&run_tests.step);

    // Benchmark executable
    const bench_exe = b.addExecutable(.{
        .name = "apz-benchmark",
        .root_source_file = .{ .path = "benchmark/server_bench.zig" },
        .target = target,
        .optimize = optimize,
    });

    bench_exe.addModule("spice", spice_dep.module("spice"));
    bench_exe.addModule("router", router_module);
    b.installArtifact(bench_exe);

    const bench_cmd = b.addRunArtifact(bench_exe);
    bench_cmd.step.dependOn(b.getInstallStep());
    const bench_step = b.step("benchmark", "Run the benchmark suite");
    bench_step.dependOn(&bench_cmd.step);
}