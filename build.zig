const std = @import("std");

pub fn build(b: *std.Build) void {
    // const target = b.standardTargetOptions(.{});
    // const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("zig_libraries", .{
        .root_source_file = b.path("src/zl.zig"),
    });

    // const lib = b.addLibrary(.{
    //     .name = "zig_libraries",
    //     .linkage = .static,
    //     .root_module = b.createModule(.{
    //         .root_source_file = b.path("src/zl.zig"),
    //         .target = target,
    //         .optimize = optimize,
    //     }),
    // });
    // b.installArtifact(lib);
}
