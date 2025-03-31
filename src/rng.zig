pub fn Rng(comptime T: type, beg: T, end: T) _Rng(T) {
  return .{ .asc = beg < end, .beg = beg, .end = end };
}

fn _Rng(comptime T: type) type {
  return struct {
    asc: bool,
    beg: T,
    end: T,

    pub fn next(self: *@This()) ?T {
      if (self.beg == self.end) { return null; }
      if (self.asc) {
        defer self.beg += 1;
        return self.beg;
      } else {
        defer self.beg -= 1;
        return self.beg - 1;
      }
    }
  };
}
