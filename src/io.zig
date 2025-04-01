const std = @import("std");

pub fn scan(comptime T: type) ?T {
  const stdin = std.io.getStdIn().reader();
  const static = struct {
    var buf: [1 << 12]u8 = undefined; // [.... ..][.. ....] -> ?
    var len: usize = 0;
    var cur: usize = 0;
  };
  // var str: Str = .{};
  if (static.cur == static.len) {
    static.cur = 0;
    static.len = stdin.read(static.buf[0 .. ]) catch @panic("error: scan()");
    if (static.cur == static.len) { return null; }
  }

  // static.cur = std.mem.indexOfNone(
  //     u8, static.buf[static.cur .. static.len], " \t\n\r") orelse static.len;
  // const l = static.cur;
  // static.cur = std.mem.indexOfAny(
  //     u8, static.buf[static.cur .. static.len], " \t\n\r") orelse static.len;
  // static.buf[l .. static.cur];
  //
  // const info = @typeInfo(T);
  // return switch (info) {
  //   .int => std.fmt.parseInt(T, nextWord(self), 10) catch unreachable,
  //   .float => std.fmt.parseFloat(T, nextWord(self)) catch unreachable,
  //   .pointer => if (info.pointer.child == u8) (nextWord(self)) else (unreachable),
  //   else => unreachable,
  // };
}

pub fn print(comptime fmt: []const u8, args: anytype) void {
  const stdout = std.io.getStdOut().writer();
  stdout.print(fmt, args) catch @panic("error: print()");
}
