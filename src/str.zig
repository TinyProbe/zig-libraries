const std = @import("std");
const string_h = @cImport(@cInclude("string.h")); // need -lc
const Rng = @import("rng.zig").Rng;

pub const Str = @import("./vec.zig").Vec(u8);

pub fn compare(lhs: Str, rhs: Str) i32 {
  return compareSlice(lhs.data(), rhs.data());
}

pub fn compareRange(lhs: Rng([*]u8), rhs: Rng([*]u8)) i32 {
  return compareSlice(lhs.left[0 .. lhs.right - lhs.left],
                      rhs.left[0 .. rhs.right - rhs.left]);
}

pub fn compareSlice(lhs: []const u8, rhs: []const u8) i32 {
  return @intCast(string_h.strcmp(@ptrCast(lhs), @ptrCast(rhs)));
}

pub fn parse(comptime T: type, str: Str) !T {
  return parseSlice(T, str.data());
}

pub fn parseSlice(comptime T: type, slice: []const u8) !T {
  return switch (@typeInfo(T)) {
    .int => try std.fmt.parseInt(T, slice, 10),
    .float => try std.fmt.parseFloat(T, slice),
    else => error.NotSupportedType,
  };
}
