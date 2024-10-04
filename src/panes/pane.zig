const std = @import("std");

const Self = @This();

// Panes are essentially nodes in a tree, this is a empty pane representation.
width: usize,
height: usize,
panes: ArrayList(*Self),

pub fn deinit(self: *Self) !void {
    // This should propagate upwards.
    _ = self;
}
