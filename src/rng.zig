pub fn Rng(comptime T: type) type {
  return struct {
    left: T,
    right: T,

    pub const Self = @This();

    pub fn init(left: T, right: T) Self {
      switch (@typeInfo(T)) {
        .pointer =>
          if (@as(usize, @intFromPtr(left)) > @as(usize, @intFromPtr(right)))
            @panic("Rng(T).init(): left > right"),
        .int => if (left > right) @panic("Rng(T).init(): left > right"),
        else => @panic("Rng(T).init(): NotSupportedType"),
      }
      return .{ .left = left, .right = right };
    }

    pub fn next(self: *Self) ?T {
      if (self.left == self.right) { return null; }
      defer self.left += 1;
      return self.left;
    }

    pub fn prev(self: *Self) ?T {
      if (self.left == self.right) { return null; }
      defer self.right -= 1;
      return self.right - 1;
    }
  };
}
