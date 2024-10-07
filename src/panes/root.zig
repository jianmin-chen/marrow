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
    const height: f32 = @as(f32, @floatFromInt(config.ui_font_size)) * 1.1;
    const bottom: f32 = config.height;
    try cellui.Box.draw(.{
        .x = 0,
        .y = bottom - height,
        .width = @floatFromInt(config.width),
        .height = height,
        .color = config.status_bar_background
    });
    // try cellui.Text.draw(.{
    //     .x = 0,
    //     .y = bottom - height,
    //     .font_path = config._buffer_font_path,
    //     .font_size = config.ui_font_size
    // });
}
