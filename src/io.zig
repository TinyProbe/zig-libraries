const std = @import("std");
const parseSlice = @import("./str.zig").parseSlice;

pub var bufferedReader = std.io.bufferedReader(std.io.getStdIn().reader());
pub var bufferedWriter = std.io.bufferedWriter(std.io.getStdOut().writer());

fn readByte() ?u8 {
    const reader = bufferedReader.reader();
    const static = struct {
        var buf: [1 << 12]u8 = undefined;
        var len: usize = 0;
        var cur: usize = 0;
    };
    if (static.cur == static.len) {
        static.cur = 0;
        static.len = reader.read(static.buf[0 .. static.buf.len]) catch {
            @panic("readByte(): Error");
        };
        if (static.len == 0) { return null; }
    }
    defer static.cur += 1;
    return static.buf[static.cur];
}

pub fn scan(comptime T: type) T {
    const static = struct {
        var buf: [1 << 20]u8 = undefined;
        var cur: usize = undefined;
    };
    static.cur = 0;
    while (readByte()) |byte| {
        if (std.ascii.isWhitespace(byte)) { continue; }
        static.buf[static.cur] = byte;
        static.cur += 1;
        break;
    }
    while (readByte()) |byte| {
        if (std.ascii.isWhitespace(byte)) { break; }
        static.buf[static.cur] = byte;
        static.cur += 1;
    }
    return parseSlice(T, static.buf[0 .. static.cur]) catch {
        @panic("scan(): Error");
    };
}

// need bufferedWriter.flush() explicitly in the execution flow.
pub fn print(comptime fmt: []const u8, args: anytype) void {
    const writer = bufferedWriter.writer();
    writer.print(fmt, args) catch @panic("print(): Error");
}
