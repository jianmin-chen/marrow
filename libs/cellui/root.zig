const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const std = @import("std");

pub const math = @import("math.zig");
pub const Box = @import("elements/box.zig");
pub const Shader = @import("elements/shader.zig");

const Allocator = std.mem.Allocator;
const assert = std.debug.assert;

pub fn setup(allocator: Allocator) !void {
    try Box.init(allocator);
}

pub fn scale(width: f32, height: f32) void {
    const projection = math.Matrix.ortho(0, width, 0, height);
    _ = projection;
    // c.glUniformMatrix4fv(
    //     Box.shader.uniform("projection"),
    //     1,
    //     c.GL_FALSE,
    //     @ptrCast(&projection)
    // );
}

pub fn cleanup() void {
    Box.deinit();
    c.glfwTerminate();
}
