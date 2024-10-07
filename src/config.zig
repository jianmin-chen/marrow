const std = @import("std");

const Self = @This();

ui_font_size: usize = 16,
ui_font_family: []const u8 = "Inter",
_ui_font_path: ?[]const u8 = "resources/cross/Inter-Variable.ttf",
buffer_font_size: usize = 14,
buffer_font_family: []const u8 = "JetBrains Mono",
_buffer_font_path: ?[]const u8 = "resources/cross/JetBrainsMono-Regular.ttf",
tab_size: usize = 4,
line_height: f32 = 1.1,

editor_background: [3]f32 = [3]f32{ 40.0 / 255.0, 44.0 / 255.0, 52.0 / 255.0 },

status_bar_background: [3]f32 = [3]f32{ 33.0 / 255.0, 37.0 / 255.0, 43.0 / 255.0 },

initial_width: c_int = 888,
initial_height: c_int = 888,
initial_name: []const u8 = "Marrow",

debug: bool = true,

width: usize = 888,
height: usize = 888,

pub fn default() Self {
    return .{};
}
