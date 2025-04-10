const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const linkage = b.option(std.builtin.LinkMode, "linkage", "") orelse .static;
    const lib = b.addLibrary(.{
        .name = "zig_libraries",
        .linkage = linkage,
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/zl.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(lib);
}
