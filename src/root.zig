pub fn Rng(comptime T: type, beg: T, end: T) _Rng(T) {
  return .{ .asc = beg < end, .beg = beg, .end = end };
}

fn _Rng(comptime T: type) type {
  return struct {
    asc: bool,
    beg: T,
    end: T,

    pub fn next(self: *@This()) ?T { return move(self, 1); }

    pub fn move(self: *@This(), dist: usize) ?T {
      if (self.beg == self.end) { return null; }
      if (self.asc) {
        defer self.beg += @min(self.end - self.beg, dist);
        return self.beg;
      } else {
        defer self.beg -= @min(self.beg - self.end, dist);
        return self.beg - 1;
      }
    }
  };
}
