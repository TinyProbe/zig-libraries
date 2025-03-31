pub fn Rng(comptime T: type, left: T, right: T) _Rng(T) {
  if (left > right) unreachable;
  return .{ .left = left, .right = right };
}

fn _Rng(comptime T: type) type {
  return struct {
    left: T,
    right: T,

    pub fn next(self: *@This()) ?T {
      if (self.left == self.right) { return null; }
      defer self.left += 1;
      return self.left;
    }

    pub fn prev(self: *@This()) ?T {
      if (self.left == self.right) { return null; }
      defer self.right -= 1;
      return self.right - 1;
    }
  };
}
