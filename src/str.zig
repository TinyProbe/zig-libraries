const std = @import("std");
const stdc = @cImport(@cInclude("string.h")); // need -lc
const Rng = @import("rng.zig").Rng;

pub const Str = @import("./vec.zig").Vec(u8);

pub fn compare(lhs: Str, rhs: Str) i32 {
  return @intCast(stdc.strcmp(
          @ptrCast(lhs.arrayList.items),
          @ptrCast(rhs.arrayList.items)));
}

pub fn compareRange(lhs: Rng([*]u8), rhs: Rng([*]u8)) i32 {
  return @intCast(stdc.strcmp(
          @ptrCast(lhs.left[0 .. lhs.right - lhs.left]),
          @ptrCast(rhs.left[0 .. rhs.right - rhs.left])));
}

pub fn compareSlice(lhs: []const u8, rhs: []const u8) i32 {
  return @intCast(stdc.strcmp(@ptrCast(lhs), @ptrCast(rhs)));
}

pub fn parse(comptime T: type, str: Str) !T {
  return switch (@typeInfo(T)) {
    .int => try std.fmt.parseInt(T, str.arrayList.items, 10),
    .float => try std.fmt.parseFloat(T, str.arrayList.items),
    else => error.NotSupportedType,
  };
}
