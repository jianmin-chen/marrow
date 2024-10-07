const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
    @cInclude("ft.h");
});
const std = @import("std");
const cellui = @import("cellui");
const Config = @import("config");

const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const panic = std.debug.panic;

const Pane = @import("panes/pane.zig");
const RootPane = @import("panes/root.zig");
const Document = @import("panes/document/document.zig");

const Self = @This();

allocator: Allocator,
config: Config,

// There is always a root pane that represents the window.
// The root pane is responsible for rendering status bar, debug info,
// and passing down state through the pane tree presumably.
root_pane: *Pane,

window: ?*c.GLFWwindow = null,
width: ?c_int = null,
height: ?c_int = null,

pub fn from(allocator: Allocator) !Self {
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    _ = args.skip();

    const self: Self = .{
        .allocator = allocator,
        .config = Config.default(),
        .root_pane = try Pane.init(allocator, try RootPane.init(allocator))
    };

    if (args.next()) |path| {
        _ = path;
        // self.pane_tree = try Pane.init(allocator, try Document.from(allocator, path));
        return self;
    }

    return self;
}

pub fn deinit(self: *Self) void {
    self.root_pane.deinit();
    self.allocator.destroy(self.root_pane);
    cellui.cleanup();
}

fn resize(_: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    c.glViewport(0, 0, width, height);
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
    _ = c.glfwSetFramebufferSizeCallback(self.window, resize);

    if (c.gladLoadGLLoader(@ptrCast(&c.glfwGetProcAddress)) == c.GL_FALSE)
        panic("Error initializing GLAD.\n", .{});

    c.glEnable(c.GL_CULL_FACE);
    c.glEnable(c.GL_BLEND);
    c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);

    try cellui.setup(self.allocator);
    cellui.scale(
        @floatFromInt(self.config.initial_width),
        @floatFromInt(self.config.initial_height)
    );

    try self.loop();
}

fn loop(self: *Self) !void {
    var prev = c.glfwGetTime();
    var frames: isize = 0;
    while (c.glfwWindowShouldClose(self.window) == 0) {
        c.glClearColor(self.config.editor_background[0], self.config.editor_background[1], self.config.editor_background[2], 1.0);
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        const timestamp = c.glfwGetTime();
        frames += 1;
        if (timestamp - prev >= 1.0) {
            std.debug.print("{any}\n", .{frames});
            frames = 0;
            prev = timestamp;
        }

        try self.root_pane.render(&self.config);

        c.glfwSwapBuffers(self.window);
        c.glfwPollEvents();
    }
}
