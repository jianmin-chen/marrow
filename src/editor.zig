const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
    @cInclude("ft.h");
});
const std = @import("std");
const Config = @import("config.zig");

const Allocator = std.mem.Allocator;
const panic = std.debug.panic;

const Document = @import("panes/document/document.zig");

const Self = @This();

allocator: Allocator,
config: Config,
open: ?Document = null,

window: ?*c.GLFWwindow = null,
width: ?c_int = null,
height: ?c_int = null,

pub fn from(allocator: Allocator) !Self {
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    _ = args.skip();

    if (args.next()) |path| {
        return .{
            .allocator = allocator,
            .config = Config.default(),
            .open = try Document.from(allocator, path)
        };
    }

    return .{
        .allocator = allocator,
        .config = Config.default()
    };
}

pub fn deinit(self: *Self) void {
    if (self.open) |document| {
        @constCast(&document).deinit();
    }
}

pub fn run(self: *Self) !void {
    defer self.deinit();

    if (c.glfwInit() == c.GL_FALSE)
        panic("Error initializing GLFW.\n", .{});
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);
    if (comptime @import("builtin").os.tag == .macos)
        c.glfwWindowHint(c.GLFW_OPENGL_FORWARD_COMPAT, c.GL_TRUE);

    self.window = c.glfwCreateWindow(
        self.config.initial_width,
        self.config.initial_height,
        @ptrCast(self.config.initial_name),
        null,
        null
    );
    if (self.window == null) {
        c.glfwTerminate();
        panic("Error creating GLFW window.\n", .{});
    }
    c.glfwMakeContextCurrent(self.window);

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == c.GL_FALSE)
        panic("Error initializing GLAD.\n", .{});

    c.glEnable(c.GL_CULL_FACE);
    c.glEnable(c.GL_BLEND);
    c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);

    try self.loop();
}

fn loop(self: *Self) !void {
    while (c.glfwWindowShouldClose(self.window) == 0) {
        c.glClearColor(40.0 / 255.0, 44.0 / 255.0, 52.0 / 255.0, 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(self.window);
        c.glfwPollEvents();
    }
}
