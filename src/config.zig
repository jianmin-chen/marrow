const std = @import("std");

const Self = @This();

ui_font_size: usize = 14,
buffer_font_size: usize = 14,
buffer_font_family: []const u8 = "JetBrains Mono",
_buffer_font_path: ?[]const u8 = "resources/cross/JetBrainsMono-Regular.ttf",
tab_size: usize = 4,
line_height: f64 = 1.1,

initial_width: c_int = 888,
initial_height: c_int = 888,
initial_name: []const u8 = "Marrow",

debug: bool = true,

pub fn default() Self {
    return .{};
}
