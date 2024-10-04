const std = @import("std");
const Config = @import("config");
const Position = @import("position.zig");
const Row = @import("row.zig");

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const fs = std.fs;

const Self = @This();

allocator: Allocator,
filename: []const u8,
file: fs.File,
dirty: bool = false,
rows: ArrayList(*Row),

cursor: Position = .{},

x: usize = 0,
y: usize = 0,
width: usize = 0,
height: usize = 0,

pub fn from(allocator: Allocator, path: []const u8) !*Self {
    var document = try allocator.create(Self);
    document.* = .{
        .allocator = allocator,
        .filename = path,
        .file = try fs.cwd().openFile(path, .{}),
        .rows = ArrayList(*Row).init(allocator)
    };

    var reader = document.file.reader();
    for (0..50) |_| {
        const line = try reader.readUntilDelimiterAlloc(allocator, '\n', std.math.maxInt(usize));
        defer allocator.free(line);

        try document.rows.append(try Row.from(allocator, line));

        if (try document.file.getPos() == try document.file.getEndPos())
            break;
    }

    return document;
}

pub fn deinit(self: *Self) void {
    self.file.close();
    for (self.rows.items) |row| {
        row.deinit();
    }
    self.rows.deinit();
    self.allocator.destroy(self);
}

pub fn render(self: *Self, config: *Config) !void {
    _ = self;
    std.debug.print("document, {any}", .{config});
}
