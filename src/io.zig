const std = @import("std");
const parseSlice = @import("./str.zig").parseSlice;

var cin_buf: [1 << 12]u8 = undefined;
var cout_buf: [1 << 12]u8 = undefined;
var cin_reader = std.fs.File.stdin().reader(&cin_buf);
var cout_writer = std.fs.File.stdout().writer(&cout_buf);
pub const cin = &cin_reader.interface;
pub const cout = &cout_writer.interface;

pub fn scan(comptime T: type) T {
    const static = struct {
        var buf: [1 << 20]u8 = undefined;
        var cur: usize = undefined;
    };
    static.cur = 0;
    while (cin.takeByte() catch null) |byte| {
        if (std.ascii.isWhitespace(byte)) { continue; }
        static.buf[static.cur] = byte;
        static.cur += 1;
        break;
    }
    while (cin.takeByte() catch null) |byte| {
        if (std.ascii.isWhitespace(byte)) { break; }
        static.buf[static.cur] = byte;
        static.cur += 1;
    }
    return parseSlice(T, static.buf[0 .. static.cur]) catch {
        @panic("scan(): Error");
    };
}

// need cout.flush() explicitly in the execution flow.
pub fn print(comptime fmt: []const u8, args: anytype) void {
    cout.print(fmt, args) catch @panic("print(): Error");
}
