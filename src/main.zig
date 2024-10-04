const std = @import("std");
const Editor = @import("editor.zig");
const config = @import("config");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    var editor = try Editor.from(allocator);
    try editor.run();
}
