const std = @import("std");
const str = @import("./str.zig");
const Str = str.Str;
const Rng = @import("./rng.zig").Rng;

var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
const alloc = gpa.allocator();

fn readByte() ?u8 {
  const reader = std.io.getStdIn().reader();
  const static = struct {
    var buf: [1 << 16]u8 = undefined;
    var len: usize = 0;
    var cur: usize = 0;
  };
  if (static.cur == static.len) {
    static.cur = 0;
    static.len = reader.read(static.buf[0 .. static.buf.len]) catch {
      @panic("readByte(): Error");
    };
    if (static.cur == static.len) { return null; }
  }
  defer static.cur += 1;
  return static.buf[static.cur];
}

pub fn scan(comptime T: type) T {
  var s = Str.init(alloc);
  while (readByte()) |byte| {
    if (std.ascii.isWhitespace(byte)) { continue; }
    s.push(byte) catch @panic("scan(): Error");
    break;
  }
  while (readByte()) |byte| {
    if (std.ascii.isWhitespace(byte)) { break; }
    s.push(byte) catch @panic("scan(): Error");
  }
  if (T == Str) { return s; }
  defer s.deinit();
  return str.parse(T, s) catch @panic("scan(): Error");
}

// pub fn print(comptime fmt: []const u8, args: anytype) void {
//   const writer = std.io.getStdOut().writer();
//   writer.print(fmt, args) catch @panic("print(): Error");
// }
