const std = @import("std");
const Config = @import("config");

const Allocator = std.mem.Allocator;
const fs = std.fs;

allocator: Allocator,
path: []const u8,

x: usize = 0,
y: usize = 0,
width: usize = 0,
height: usize = 0,

pub fn from(allocator: Allocator, path: []const u8) !*Self {
    var self = try allocator.create(Self);
    self.* = .{
        .allocator = allocator,
        .path = path
    };
    return self;
}

pub fn deinit(self: *Self) void {
    self.allocator.destroy(self);
}

pub fn render(self: *Self, config: *Config) !void {
    _ = self;
    std.debug.print("filetree, {any}", .{config});
}
