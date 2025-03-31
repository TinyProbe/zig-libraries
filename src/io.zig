const std = @import("std");

var buffered_reader = std.io.bufferedReader(std.io.getStdIn().reader());
var buffered_writer = std.io.bufferedWriter(std.io.getStdOut().writer());
const reader = buffered_reader.reader();
const writer = buffered_writer.writer();

pub fn scan(comptime T: type) T {
  return Scanner.next(T) catch unreachable;
}
pub fn print(comptime format: []const u8, args: anytype) void {
  writer.print(format, args) catch unreachable;
}

const Scanner = struct {
  var buf: [1 << 24]u8 = undefined;
  var len: usize = undefined;
  var cur: usize = 0;

  pub fn scanInput() !void { len = try reader.read(buf[0 .. ]); }
  fn nextItem() []const u8 {
    while (cur < len and std.ascii.isWhitespace(buf[cur])) { cur += 1; }
    const l = cur;
    while (cur < len and !std.ascii.isWhitespace(buf[cur])) { cur += 1; }
    return buf[l .. cur];
  }
  pub fn next(comptime T: type) !T {
    const info = @typeInfo(T);
    return switch (info) {
      .int => try std.fmt.parseInt(T, nextItem(), 10),
      .float => try std.fmt.parseFloat(T, nextItem()),
      .pointer => if (info.pointer.child == u8) (nextItem()) else (error.NotSupportedType),
      else => error.NotSupportedType,
    };
  }
};
