const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "hello",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe.linkLibC();
    // exe.addSystemIncludePath(b.re("/usr/local/include"));
    exe.linkSystemLibrary("SDL3");

    b.installArtifact(exe);

    // build shared library from audio.zig

    const lib_aud = b.addSharedLibrary(.{
        .name = "aud",
        .root_source_file = b.path("src/audio.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib_aud.linkLibC();
    lib_aud.linkSystemLibrary("SDL3");
    b.installArtifact(lib_aud);
}
