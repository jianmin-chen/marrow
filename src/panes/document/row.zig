const std = @import("std");
const String = @import("string");

const Allocator = std.mem.Allocator;

const Self = @This();

allocator: Allocator,
string: String,

pub fn from(allocator: Allocator, slice: []const u8) !*Self {
    const self = try allocator.create(Self);
    self.* = .{
        .allocator = allocator,
        .string = try String.from(allocator, std.mem.trim(u8, slice, '\n'))
    };
    return self;
}

pub fn deinit(self: *Self) void {
    self.string.deinit();
    self.allocator.destroy(self);
}

pub fn value(self: *Self) []u8 {
    return self.string.value;
}
