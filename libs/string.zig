const std = @import("std");

const Allocator = std.mem.Allocator;

const Self = @This();

allocator: Allocator,
value: []u8,
len: usize,

pub fn from(allocator: Allocator, slice: []const u8) !Self {
    return .{
        .allocator = allocator,
        .value = try allocator.dupe(u8, slice),
        .len = slice.len
    };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.value);
}
