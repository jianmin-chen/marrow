const std = @import("std");
const Config = @import("config");

const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

const Self = @This();

ptr: *anyopaque,
pane: *const Pane,

const Pane = struct {
    deinit: *const fn (ptr: *anyopaque) void,
    render: *const fn (ptr: *anyopaque, config: *Config) anyerror!void
};

pub fn deinit(self: Self) void {
    self.pane.deinit(self.ptr);
}

pub fn render(self: Self, config: *Config) anyerror!void {
    try self.pane.render(self.ptr, config);
}

pub fn init(allocator: Allocator, pane: anytype) !*Self {
    const Ptr = @TypeOf(pane);
    const PtrInfo = @typeInfo(Ptr);

    assert(PtrInfo == .Pointer);
    assert(PtrInfo.Pointer.size == .One);
    assert(@typeInfo(PtrInfo.Pointer.child) == .Struct);

    const alignment = PtrInfo.Pointer.alignment;

    const impl = struct {
        fn deinit(ptr: *anyopaque) void {
            const self: Ptr align(alignment) = @ptrCast(@alignCast(ptr));
            self.deinit();
        }

        fn render(ptr: *anyopaque, config: *Config) anyerror!void {
            const self: Ptr align(alignment) = @ptrCast(@alignCast(ptr));
            try self.render(config);
        }
    };

    const wrapper = try allocator.create(Self);
    wrapper.* = .{
        .ptr = pane,
        .pane = &.{
            .deinit = impl.deinit,
            .render = impl.render
        }
    };
    return wrapper;
}
