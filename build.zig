const std = @import("std");

pub fn build(b: *std.Build) void {
  _ = b.addModule("zig_libraries", .{
    .root_source_file = b.path("src/zl.zig"),
  });
}
