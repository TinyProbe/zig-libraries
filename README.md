# zig-libraries

## Installation

Fetch zig-libraries to `build.zig.zon`:

```bash
zig fetch --save git+https://github.com/TinyProbe/zig-libraries
```

And then add dependency to `build.zig`:

```zig
const zl = b.dependency("zig_libraries", .{});
exe.root_module.addImport("zig_libraries", zl.module("zig_libraries"));
```

build and run:

```bash
zig build
./zig-out/bin/...
```

## Example

`src/main.zig`:

```zig
const std = @import("std");
const zl = @import("zig_libraries");

var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
const alloc = gpa.allocator();

pub fn main() !void {
  defer if (gpa.deinit() == .leak) unreachable;
  defer zl.bufferedWriter.flush() catch unreachable;

  var s = zl.Str.init(alloc); defer s.deinit();
  try s.appendSlice("hello world!");
  zl.print("{s}\n", .{ s.items });

  var v = zl.Vec(usize).init(alloc); defer v.deinit();
  var rng = zl.Rng(usize).init(1, 101);
  while (rng.next()) |i| {
    try v.push(i);
  }
  zl.print("{d}\n", .{ v.items[10] });
}
```
