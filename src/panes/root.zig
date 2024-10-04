const std = @import("std");
const cellui = @import("cellui");
const Config = @import("config");

const Allocator = std.mem.Allocator;

const Self = @This();

allocator: Allocator,

pub fn init(allocator: Allocator) !*Self {
    const self = try allocator.create(Self);
    self.* = .{ .allocator = allocator };
    return self;
}

pub fn deinit(self: *Self) void {
    self.allocator.destroy(self);
}

pub fn render(self: *Self, config: *Config) !void {
    _ = self;
    _ = config;
    try cellui.Box.draw(.{
        .x = 0,
        .y = 0,
        .width = 888,
        .height = 888
    });
}
