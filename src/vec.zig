const std = @import("std");
const Rng = @import("./rng.zig").Rng;
const Allocator = std.mem.Allocator;

// check self to self at all functions

pub fn Vec(comptime T: type) type {
  return struct {
    arrayList: std.ArrayList(T),

    pub const Self = @This();

    pub fn init(allocator: Allocator) Self {
      return .{ .arrayList = std.ArrayList(T).init(allocator) };
    }

    pub fn deinit(self: Self) void {
      self.arrayList.deinit();
    }

    pub fn assign(self: *Self, obj: *const Self) Allocator.Error!void {
      if (self == obj) { return; }
      try self.arrayList.resize(0);
      try self.arrayList.appendSlice(obj.arrayList.items);
    }

    pub fn assignSlice(self: *Self, slice: []const T) Allocator.Error!void {
      const self_l: usize = @intFromPtr(self.arrayList.items.ptr);
      const self_r: usize = @intFromPtr(
          self.arrayList.items.ptr + self.arrayList.items.len);
      const slice_l: usize = @intFromPtr(slice.ptr);
      const slice_r: usize = @intFromPtr(slice.ptr + slice.len);
      if (self_r <= slice_l or self_l >= slice_r) {
        try self.arrayList.resize(0);
        try self.arrayList.appendSlice(slice);
      } else {
        std.mem.copyForwards(T, self.arrayList.items[0 .. slice.len], slice);
        try self.arrayList.resize(slice.len);
      }
    }

    pub fn assignNTimes(self: *Self, n: usize, item: T) Allocator.Error!void {
      try self.arrayList.resize(0);
      try self.arrayList.appendNTimes(item, n);
    }

    pub fn append(self: *Self, obj: Self) Allocator.Error!void {
      try self.arrayList.appendSlice(obj.arrayList.items);
    }

    pub fn appendSlice(self: *Self, slice: []const T) Allocator.Error!void {
      try self.arrayList.appendSlice(slice);
    }

    pub fn appendNTimes(self: *Self, n: usize, item: T) Allocator.Error!void {
      try self.arrayList.appendNTimes(item, n);
    }

    pub fn insert(
        self: *Self, pos: usize, obj: *const Self) Allocator.Error!void {
      if (self == obj) {
        const n = obj.arrayList.items.len;
        try self.arrayList.resize(self.arrayList.items.len + n);
        std.mem.copyBackwards(
            T,
            self.arrayList.items[pos + n .. self.arrayList.items.len],
            self.arrayList.items[pos .. self.arrayList.items.len - n]);
        @memcpy(self.arrayList.items[pos .. pos + pos],
                self.arrayList.items[0 .. pos]);
        @memcpy(self.arrayList.items[pos + pos .. pos + n],
                self.arrayList.items[pos + n .. self.arrayList.items.len]);
      } else {
        try self.arrayList.insertSlice(pos, obj.arrayList.items);
      }
    }

    pub fn insertSlice(
        self: *Self, pos: usize, slice: []const T) Allocator.Error!void {
      try self.arrayList.insertSlice(pos, slice);
    }

    pub fn insertNTimes(
        self: *Self, pos: usize, n: usize, item: T) Allocator.Error!void {
      try self.arrayList.resize(self.arrayList.items.len + n);
      std.mem.copyBackwards(
          T,
          self.arrayList.items[pos + n .. self.arrayList.items.len],
          self.arrayList.items[pos .. self.arrayList.items.len - n]);
      @memset(self.arrayList.items[pos .. pos + n], item);
    }

    pub fn replace(self: *Self, pos: usize, obj: Self) void {
      const items = obj.arrayList.items;
      self.arrayList.replaceRange(pos, items.len, items) catch unreachable;
    }

    pub fn replaceSlice(self: *Self, pos: usize, slice: []const T) void {
      self.arrayList.replaceRange(pos, slice.len, slice) catch unreachable;
    }

    pub fn replaceNTimes(self: *Self, pos: usize, n: usize, item: T) void {
      @memset(self.arrayList.items[pos .. pos + n], item);
    }

    pub fn find(self: Self, pos: usize, obj: Self) ?usize {
      return std.mem.indexOfPos(
          T, self.arrayList.items, pos, obj.arrayList.items);
    }

    pub fn findSlice(self: Self, pos: usize, slice: []const T) ?usize {
      return std.mem.indexOfPos(T, self.arrayList.items, pos, slice);
    }

    pub fn findItem(self: Self, pos: usize, item: T) ?usize {
      return std.mem.indexOfScalarPos(T, self.arrayList.items, pos, item);
    }

    pub fn findAny(self: Self, pos: usize, values: []const T) ?usize {
      return std.mem.indexOfAnyPos(T, self.arrayList.items, pos, values);
    }

    pub fn findNone(self: Self, pos: usize, values: []const T) ?usize {
      return std.mem.indexOfNonePos(T, self.arrayList.items, pos, values);
    }

    pub fn rfind(self: Self, obj: Self) ?usize {
      return std.mem.lastIndexOf(
          T, self.arrayList.items, obj.arrayList.items);
    }

    pub fn rfindSlice(self: Self, slice: []const T) ?usize {
      return std.mem.lastIndexOf(T, self.arrayList.items, slice);
    }

    pub fn rfindItem(self: Self, item: T) ?usize {
      return std.mem.lastIndexOfScalar(T, self.arrayList.items, item);
    }

    pub fn rfindAny(self: Self, values: []const T) ?usize {
      return std.mem.lastIndexOfAny(T, self.arrayList.items, values);
    }

    pub fn rfindNone(self: Self, values: []const T) ?usize {
      return std.mem.lastIndexOfNone(T, self.arrayList.items, values);
    }

    pub fn reverse(self: Self) void {
      std.mem.reverse(T, self.arrayList.items);
    }

    pub fn sort(self: Self) void {
      std.mem.sort(T, self.arrayList.items, {}, std.sort.asc(T));
    }

    pub fn clone(self: Self) Allocator.Error!Self {
      return .{ .arrayList = try self.arrayList.clone() };
    }

    pub fn cloneRange(
        self: Self, left: usize, right: usize) Allocator.Error!Self {
      var rtn = Self {
        .arrayList = std.ArrayList(T).init(self.arrayList.allocator) };
      try rtn.arrayList.appendSlice(self.arrayList.items[left .. right]);
      return rtn;
    }

    pub fn attach(self: Self, obj: Self) Allocator.Error!Self {
      var rtn = Self {
        .arrayList = std.ArrayList(T).init(self.arrayList.allocator) };
      try rtn.arrayList.appendSlice(self.arrayList.items);
      try rtn.arrayList.appendSlice(obj.arrayList.items);
      return rtn;
    }

    pub fn detach(self: Self, pos: usize) Allocator.Error![2]Self {
      var rtn = [2]Self {
        .{ .arrayList = std.ArrayList(T).init(self.arrayList.allocator) },
        .{ .arrayList = std.ArrayList(T).init(self.arrayList.allocator) },
      };
      const items = self.arrayList.items;
      try rtn[0].arrayList.appendSlice(items[0 .. pos]);
      try rtn[1].arrayList.appendSlice(items[pos .. items.len]);
      return rtn;
    }

    pub fn copy(self: Self, target: []T, left: usize, right: usize) void {
      @memcpy(target, self.arrayList.items[left .. right]);
    }

    pub fn push(self: *Self, item: T) Allocator.Error!void {
      try self.arrayList.append(item);
    }

    pub fn pop(self: *Self) ?T {
      return self.arrayList.pop();
    }

    pub fn swapPop(self: *Self, pos: usize) ?T {
      return
          if (pos < self.arrayList.items.len) (self.arrayList.swapRemove(pos))
          else (null);
    }

    pub fn remove(self: *Self, pos: usize) T {
      return self.arrayList.orderedRemove(pos);
    }

    pub fn removeRange(self: *Self, left: usize, right: usize) void {
      const items = self.arrayList.items;
      const dist = right - left;
      std.mem.copyForwards(
          T, items[left .. items.len - dist], items[right .. items.len]);
      self.arrayList.resize(items.len - dist) catch unreachable;
    }

    pub fn resize(self: *Self, count: usize) Allocator.Error!void {
      self.arrayList.resize(count);
    }

    pub fn clear(self: *Self) void {
      self.arrayList.clearAndFree();
    }

    pub fn shrink(self: *Self) void {
      self.arrayList.shrinkAndFree();
    }

    pub fn swap(self: *Self, obj: *Self) void {
      std.mem.swap(Self, self, obj);
    }

    pub fn data(self: Self) []T {
      return self.arrayList.items;
    }

    pub fn at(self: Self, pos: usize) ?T {
      const items = self.arrayList.items;
      return if (pos < items.len) (items[pos]) else (null);
    }

    pub fn front(self: Self) ?T {
      const items = self.arrayList.items;
      return if (0 < items.len) (items[0]) else (null);
    }

    pub fn back(self: Self) ?T {
      const items = self.arrayList.items;
      return if (0 < items.len) (items[items.len - 1]) else (null);
    }

    pub fn begin(self: Self) [*]T {
      return @ptrCast(self.arrayList.items);
    }

    pub fn end(self: Self) [*]T {
      const ptr: [*]T = @ptrCast(self.arrayList.items);
      return ptr + self.arrayList.items.len;
    }

    pub fn iterRange(self: Self, left: usize, right: usize) Rng([*]T) {
      const ptr: [*]T = @ptrCast(self.arrayList.items);
      return Rng([*]T).init(ptr + left, ptr + right);
    }

    pub fn empty(self: Self) bool {
      return self.arrayList.items.len == 0;
    }

    pub fn size(self: Self) usize {
      return self.arrayList.items.len;
    }

    pub fn length(self: Self) usize {
      return self.arrayList.items.len;
    }

    pub fn capacity(self: Self) usize {
      return self.arrayList.capacity;
    }
  };
}
