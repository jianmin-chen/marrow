const std = @import("std");

const Build = std.Build;

fn attachDependencies(b: *Build, exe: *Build.Step.Compile) void {
    exe.addIncludePath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/glfw/3.4/include" });
    exe.addLibraryPath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/glfw/3.4/lib" });
    exe.addIncludePath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/freetype/2.13.3/include/freetype2/" });
    exe.addLibraryPath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/freetype/2.13.3/lib" });
    exe.addIncludePath(b.path("./deps"));
    exe.addCSourceFile(.{
        .file = b.path("./deps/glad.c"),
        .flags = &.{}
    });
    exe.linkFramework("OpenGL");
    exe.linkSystemLibrary("glfw");
    exe.linkSystemLibrary("freetype");
}

pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "Marrow",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize
    });

    attachDependencies(b, exe);

    const config = b.addModule("config", .{
        .root_source_file = b.path("src/config.zig")
    });
    exe.root_module.addImport("config", config);

    const string = b.addModule("string", .{
        .root_source_file = b.path("libs/string.zig")
    });
    exe.root_module.addImport("string", string);

    const cellui = b.addModule("cellui", .{
        .root_source_file = b.path("libs/cellui/root.zig"),
        .target = target
    });
    cellui.addIncludePath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/glfw/3.4/include" });
    cellui.addLibraryPath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/glfw/3.4/lib" });
    cellui.addIncludePath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/freetype/2.13.3/include/freetype2/" });
    cellui.addLibraryPath(Build.LazyPath{ .cwd_relative = "/opt/homebrew/Cellar/freetype/2.13.3/lib" });
    cellui.addIncludePath(b.path("./deps"));
    cellui.linkFramework("OpenGL", .{});
    cellui.linkSystemLibrary("glfw", .{});
    cellui.linkSystemLibrary("freetype", .{});
    exe.root_module.addImport("cellui", cellui);

    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    const run_step = b.step("run", "Run app");
    run_step.dependOn(&run_exe.step);
}
