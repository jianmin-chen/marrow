const std = @import("std");
const cellui = @import("cellui");

const Allocator = std.mem.Allocator;

pub fn main() !void {
    try cellui.Window.open(initial_width, initial_height);

    while (true) {
        try cellui.Window.refresh();
        try cellui.Box.draw(0, 0, 500, 500);
    }
}
