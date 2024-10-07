const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});
const std = @import("std");
const Shader = @import("shader.zig");

pub const vertex =
    \\#version 330 core
    \\
    \\layout (location = 0) in vec4 vertex;
    \\
    \\out vec2 tex_coords;
    \\
    \\uniform mat4 projection;
    \\
    \\void main() {
    \\    gl_Position = projection * vec4(vertex.xy, 0.0, 1.0);
    \\    tex_coords = vertex.zw;
    \\}
;

pub const fragment =
    \\#version 330 core
    \\
    \\in vec2 tex_coords;
    \\
    \\out vec4 color;
    \\
    \\uniform sampler2D text;
    \\uniform vec3 text_color;
    \\
    \\void main() {
    \\    vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, tex_coords).r);
    \\    color = vec4(text_color, 1.0) * sampled;
    \\}
;

pub const Character = struct {
    repr: usize,
    texture_id: c_uint,
    width: f32,
    height: f32,
    bearing_x: f32,
    bearing_y: f32,
    advance_x: c_long,
    advance_y: c_long
};

pub var shader: Shader = undefined;

const Self = @This();

pub fn init(allocator: Allocator) !void {
    _ = allocator;
    Self.shader = try Shader.init()
}
