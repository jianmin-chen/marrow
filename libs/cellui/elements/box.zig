const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const std = @import("std");
const Shader = @import("shader.zig");

const Allocator = std.mem.Allocator;

pub const vertex: []const u8 =
    \\#version 330 core
    \\
    \\layout (location = 0) in vec2 pos;
    \\
    \\uniform mat4 projection;
    \\
    \\void main() {
    \\    gl_Position = projection * vec4(pos, 0.0, 1.0);
    \\}
;

pub const fragment: []const u8 =
    \\#version 330 core
    \\
    \\out vec4 color;
    \\
    \\uniform vec3 box_color;
    \\
    \\void main() {
    \\    color = vec4(box_color, 1.0);
    \\}
;

const indices = [_]c.GLint{
    3, 1, 0,
    3, 2, 1
};

const Options = struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
    color: [3]f32
};

pub var shader: Shader = undefined;

const Self = @This();

pub fn init(allocator: Allocator) !void {
    _ = allocator;
    Self.shader = try Shader.init(vertex, fragment);

    c.glBindVertexArray(Self.shader.vao);

    c.glBindBuffer(c.GL_ARRAY_BUFFER, Self.shader.vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, @sizeOf(c.GLfloat) * 8, null, c.GL_DYNAMIC_DRAW);

    c.glBindBuffer(c.GL_ELEMENT_ARRAY_BUFFER, Self.shader.ebo);
    c.glBufferData(c.GL_ELEMENT_ARRAY_BUFFER, @sizeOf(c.GLint) * 6, @ptrCast(&indices[0]), c.GL_STATIC_DRAW);

    c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, 2 * @sizeOf(c.GLfloat), null);
    c.glEnableVertexAttribArray(0);
}

pub fn deinit() void {
    Self.shader.deinit();
}

pub fn draw(options: Options) !void {
    Self.shader.use();

    c.glUniform3fv(Self.shader.uniform("box_color"), 1, @ptrCast(&options.color[0]));

    const vertices = [_]c.GLfloat{
        options.x, options.y + options.height,
        options.x, options.y,
        options.x + options.width, options.y,
        options.x + options.width, options.y + options.height
    };

    c.glBindVertexArray(Self.shader.vao);

    c.glBindBuffer(c.GL_ARRAY_BUFFER, Self.shader.vbo);
    c.glBufferSubData(c.GL_ARRAY_BUFFER, 0, @sizeOf(c.GLfloat) * vertices.len, @ptrCast(&vertices[0]));

    c.glDrawElements(c.GL_TRIANGLES, 6, c.GL_UNSIGNED_INT, null);
}
