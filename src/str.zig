const std = @import("std");
const stdc = @cImport(@cInclude("string.h"));
const Allocator = std.mem.Allocator;

pub fn Str(allocator: Allocator) _Str(u8) {
  return .{ .arrayList = std.ArrayList(u8).init(allocator) };
}

fn _Str(comptime T: type) type {
  return struct {
    arrayList: std.ArrayList(T),

    pub const Self = @This();

    pub fn _Str(self: *Self) void { self.arrayList.deinit(); }

    // not checked
    pub fn assign(self: *Self, str: *const Self) Allocator.Error!void {
      try self.arrayList.resize(str.arrayList.items.len);
      try self.arrayList.replaceRange(
          0, str.arrayList.items.len, str.arrayList.items);
    }

    // not checked
    pub fn assignSlice(self: *Self, slice: []const T) Allocator.Error!void {
      try self.arrayList.resize(slice.len);
      try self.arrayList.replaceRange(0, slice.len, slice);
    }

    // not checked
    pub fn assignNTimes(self: *Self, n: usize, item: T) Allocator.Error!void {
      try self.arrayList.resize(0);
      try self.arrayList.appendNTimes(item, n);
    }

    // not checked
    pub fn append(self: *Self, str: *const Self) Allocator.Error!void {
      try self.arrayList.appendSlice(str.arrayList.items);
    }

    // not checked
    pub fn appendSlice(self: *Self, slice: []const T) Allocator.Error!void {
      try self.arrayList.appendSlice(slice);
    }

    // not checked
    pub fn appendNTimes(self: *Self, n: usize, item: T) Allocator.Error!void {
      try self.arrayList.appendNTimes(item, n);
    }

    // not checked
    pub fn insert(self: *Self, pos: usize, str: *const Self)
        Allocator.Error!void {
      try self.arrayList.insertSlice(pos, str.arrayList.items);
    }

    // not checked
    pub fn insertSlice(self: *Self, pos: usize, slice: []const T)
        Allocator.Error!void {
      try self.arrayList.insertSlice(pos, slice);
    }

    // not checked
    pub fn insertNTimes(self: *Self, pos: usize, n: usize, item: T)
        Allocator.Error!void {
      try self.arrayList.resize(self.arrayList.items.len + n);
      std.mem.copyBackwards(
          T,
          self.arrayList.items[pos + n .. self.arrayList.items.len],
          self.arrayList.items[pos .. self.arrayList.items.len - n]);
      @memset(self.arrayList.items[pos .. pos + n], item);
    }

    // not checked
    pub fn replace(self: *Self, pos: usize, str: *const Self) void {
      const strItems = str.arrayList.items;
      self.arrayList.replaceRange(
          pos, strItems.len, strItems) catch unreachable;
    }

    // not checked
    pub fn replaceSlice(self: *Self, pos: usize, slice: []const T) void {
      self.arrayList.replaceRange(pos, slice.len, slice) catch unreachable;
    }

    // not checked
    pub fn replaceNTimes(self: *Self, pos: usize, n: usize, item: T) void {
      @memset(self.arrayList.items[pos .. pos + n], item);
    }

    // not checked
    pub fn compare(self: *const Self, other: *const Self) i32 {
      return @intCast(stdc.strcmp(
              @ptrCast(self.arrayList.items),
              @ptrCast(other.arrayList.items)));
    }

    // not checked
    pub fn compareSlice(self: *const Self, slice: []const T) i32 {
      return @intCast(stdc.strcmp(
              @ptrCast(self.arrayList.items),
              @ptrCast(slice)));
    }

    // not checked
    pub fn compareRange(
        self: *const Self, other: *const Self, left: usize, right: usize) i32 {
      return @intCast(stdc.strcmp(
              @ptrCast(self.arrayList.items[left .. right]),
              @ptrCast(other.arrayList.items[left .. right])));
    }

    // not checked
    pub fn find(self: *const Self, pos: usize, str: *const Self) ?usize {
      return std.mem.indexOfPos(
          T, self.arrayList.items, pos, str.arrayList.items);
    }

    // not checked
    pub fn findSlice(self: *const Self, pos: usize, slice: []const T) ?usize {
      return std.mem.indexOfPos(T, self.arrayList.items, pos, slice);
    }

    // not checked
    pub fn findItem(self: *const Self, pos: usize, item: T) ?usize {
      return std.mem.indexOfScalarPos(T, self.arrayList.items, pos, item);
    }

    // not checked
    pub fn findAny(self: *const Self, pos: usize, values: []const T) ?usize {
      return std.mem.indexOfAnyPos(T, self.arrayList.items, pos, values);
    }

    // not checked
    pub fn findNone(self: *const Self, pos: usize, values: []const T) ?usize {
      return std.mem.indexOfNonePos(T, self.arrayList.items, pos, values);
    }

    // not checked
    pub fn rfind(self: *const Self, str: *const Self) ?usize {
      return std.mem.lastIndexOf(
          T, self.arrayList.items, str.arrayList.items);
    }

    // not checked
    pub fn rfindSlice(self: *const Self, slice: []const T) ?usize {
      return std.mem.lastIndexOf(T, self.arrayList.items, slice);
    }

    // not checked
    pub fn rfindItem(self: *const Self, item: T) ?usize {
      return std.mem.lastIndexOfScalar(T, self.arrayList.items, item);
    }

    // not checked
    pub fn rfindAny(self: *const Self, values: []const T) ?usize {
      return std.mem.lastIndexOfAny(T, self.arrayList.items, values);
    }

    // not checked
    pub fn rfindNone(self: *const Self, values: []const T) ?usize {
      return std.mem.lastIndexOfNone(T, self.arrayList.items, values);
    }

    // not checked
    pub fn reverse(self: *Self) void {
      std.mem.reverse(self.arrayList.items);
    }

    // not checked
    pub fn sort(self: *Self) void {
      std.mem.sort(T, self.arrayList.items, .{}, std.sort.asc(T));
    }

    // not checked
    pub fn clone(self: *const Self) Allocator.Error!Self {
      return .{ .arrayList = try self.arrayList.clone() };
    }

    // not checked
    pub fn subStr(
        self: *const Self, left: usize, right: usize) Allocator.Error!Self {
      var rtn = Self {
        .arrayList = std.ArrayList(T).init(self.arrayList.allocator)
      };
      try rtn.arrayList.appendSlice(self.arrayList.items[left .. right]);
      return rtn;
    }

    // not checked
    pub fn join(self: *const Self, other: *const Self) Allocator.Error!Self {
      var rtn = Self {
        .arrayList = std.ArrayList(T).init(self.arrayList.allocator)
      };
      try rtn.arrayList.appendSlice(self.arrayList.items);
      try rtn.arrayList.appendSlice(other.arrayList.items);
      return rtn;
    }

    // not checked
    pub fn copy(self: *const Self, paste: []T, left: usize, right: usize) void {
      @memcpy(paste, self.arrayList.items[left .. right]);
    }

    // not checked
    pub fn push(self: *Self, item: T) Allocator.Error!void {
      try self.arrayList.append(item);
    }

    // not checked
    pub fn pop(self: *Self) ?T {
      return self.arrayList.pop();
    }

    // not checked
    pub fn swapPop(self: *Self, pos: usize) ?T {
      return
          if (pos < self.arrayList.items.len) (self.arrayList.swapRemove(pos))
          else (null);
    }

    // not checked
    pub fn remove(self: *Self, pos: usize) T {
      return self.arrayList.orderedRemove(pos);
    }

    // not checked
    pub fn removeRange(self: *Self, left: usize, right: usize) void {
      const items = self.arrayList.items;
      const dist = right - left;
      std.mem.copyForwards(items[left .. items.len - dist],
                           items[right .. items.len]);
      self.arrayList.resize(items.len - dist) catch unreachable;
    }

    // not checked
    pub fn resize(self: *Self, count: usize) Allocator.Error!void {
      self.arrayList.resize(count);
    }

    // not checked
    pub fn clear(self: *Self) void {
      self.arrayList.clearAndFree();
    }

    // not checked
    pub fn shrink(self: *Self) void {
      self.arrayList.shrinkAndFree();
    }

    // not checked
    pub fn swap(self: *Self, other: *Self) void {
      std.mem.swap(Self, self, other);
    }

    // not checked
    pub fn data(self: *const Self) []T {
      return self.arrayList.items;
    }

    // not checked
    pub fn range(self: *const Self, left: usize, right: usize) []T {
      return self.arrayList.items[left .. right];
    }

    // not checked
    pub fn at(self: *const Self, pos: usize) ?T {
      const items = self.arrayList.items;
      return if (pos < items.len) (items[pos]) else (null);
    }

    // not checked
    pub fn front(self: *const Self) ?T {
      const items = self.arrayList.items;
      return if (0 < items.len) (items[0]) else (null);
    }

    // not checked
    pub fn back(self: *const Self) ?T {
      const items = self.arrayList.items;
      return if (0 < items.len) (items[items.len - 1]) else (null);
    }

    // not checked
    pub fn begin(self: *const Self) [*]T {
      return @ptrCast(self.arrayList.items);
    }

    // not checked
    pub fn end(self: *const Self) [*]T {
      const ptr: [*]T = @ptrCast(self.arrayList.items);
      return ptr + self.arrayList.items.len;
    }

    // not checked
    pub fn empty(self: *const Self) bool {
      return self.arrayList.items.len == 0;
    }

    // not checked
    pub fn size(self: *const Self) usize {
      return self.arrayList.items.len;
    }

    // not checked
    pub fn length(self: *const Self) usize {
      return self.arrayList.items.len;
    }

    // not checked
    pub fn capacity(self: *const Self) usize {
      return self.arrayList.capacity;
    }

    // not checked
    pub fn parse(self: *const Self, comptime U: type) !U {
      const info = @typeInfo(U);
      return switch (info) {
        .int => try std.fmt.parseInt(U, self.arrayList.items, 10),
        .float => try std.fmt.parseFloat(U, self.arrayList.items),
        else => error.NotSupportedType,
      };
    }
  };
}
