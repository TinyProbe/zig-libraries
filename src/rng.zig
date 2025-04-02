pub fn Rng(comptime T: type, left: T, right: T) _Rng(T) {
  return .{ .left = left, .right = right };
}

fn _Rng(comptime T: type) type {
  return struct {
    left: T,
    right: T,

    pub const Self = @This();

    pub fn next(self: *Self) ?T {
      if (self.left >= self.right) { return null; }
      defer self.left += 1;
      return self.left;
    }

    pub fn prev(self: *Self) ?T {
      if (self.left >= self.right) { return null; }
      defer self.right -= 1;
      return self.right - 1;
    }
  };
}
