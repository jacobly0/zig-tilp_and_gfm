const std = @import("std");
const tilibs_build = @import("tilibs");

pub fn build(b: *std.Build) void {
    const upstream = b.dependency("tilp_and_gfm", .{});
    const tilibs = b.dependency("tilibs", .{});
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const tilp = b.addExecutable(.{
        .name = "tilp",
        .target = target,
        .optimize = optimize,
    });
    tilp.rdynamic = true;
    tilp.linkLibC();
    tilp.linkSystemLibrary("gtk+-2.0");
    tilp.linkLibrary(tilibs.artifact("ticonv"));
    tilp.linkLibrary(tilibs.artifact("tifiles2"));
    tilp.linkLibrary(tilibs.artifact("ticables2"));
    tilp.linkLibrary(tilibs.artifact("ticalcs2"));
    tilp.defineCMacro("SHARE_DIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, ""),
    }));
    tilp.defineCMacro("VERSION", "\"1.19\"");
    tilibs_build.defineOsMacros(tilp);
    tilp.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "tilp/trunk/src/about.c",
            "tilp/trunk/src/action.c",
            "tilp/trunk/src/bookmark.c",
            "tilp/trunk/src/clist.c",
            "tilp/trunk/src/clist_rbm.c",
            "tilp/trunk/src/clock.c",
            "tilp/trunk/src/ctree.c",
            "tilp/trunk/src/ctree_rbm.c",
            "tilp/trunk/src/dboxes.c",
            "tilp/trunk/src/device.c",
            "tilp/trunk/src/dnd.c",
            "tilp/trunk/src/fileprop.c",
            "tilp/trunk/src/filesel.c",
            "tilp/trunk/src/gtk_gif.c",
            "tilp/trunk/src/gtk_update.c",
            "tilp/trunk/src/labels.c",
            "tilp/trunk/src/main.c",
            "tilp/trunk/src/manpage.c",
            "tilp/trunk/src/options.c",
            "tilp/trunk/src/pbars.c",
            "tilp/trunk/src/release.c",
            "tilp/trunk/src/screenshot.c",
            "tilp/trunk/src/scroptions.c",
            "tilp/trunk/src/splash.c",
            "tilp/trunk/src/support.c",
            "tilp/trunk/src/tilp.c",
            "tilp/trunk/src/tilp_calcs.c",
            "tilp/trunk/src/tilp_cmdline.c",
            "tilp/trunk/src/tilp_config.c",
            "tilp/trunk/src/tilp_device.c",
            "tilp/trunk/src/tilp_error.c",
            "tilp/trunk/src/tilp_files.c",
            "tilp/trunk/src/tilp_gif.c",
            "tilp/trunk/src/tilp_main.c",
            "tilp/trunk/src/tilp_misc.c",
            "tilp/trunk/src/tilp_paths.c",
            "tilp/trunk/src/tilp_screen.c",
            "tilp/trunk/src/tilp_slct.c",
            "tilp/trunk/src/tilp_update.c",
            "tilp/trunk/src/tilp_vars.c",
            "tilp/trunk/src/toolbar.c",
        },
    });
    for ([_][]const u8{
        "pixmaps", "help", "icons", "builder", "desktop",
    }) |dir| b.installDirectory(.{
        .source_dir = upstream.path(b.pathJoin(&.{
            "tilp", "trunk", dir,
        })),
        .install_dir = .{ .custom = "share" },
        .install_subdir = dir,
    });
    b.installArtifact(tilp);

    const gfm = b.addExecutable(.{
        .name = "gfm",
        .target = target,
        .optimize = optimize,
    });
    gfm.rdynamic = true;
    gfm.linkLibC();
    gfm.linkSystemLibrary("glade-2.0");
    gfm.addIncludePath(.{ .path = "/usr/include/libglade-2.0" });
    gfm.linkSystemLibrary("gtk+-2.0");
    gfm.linkLibrary(tilibs.artifact("ticonv"));
    gfm.linkLibrary(tilibs.artifact("ticalcs2"));
    gfm.defineCMacro("SHARE_DIR", b.fmt("\"{s}\"", .{
        b.getInstallPath(.{ .custom = "share" }, ""),
    }));
    gfm.defineCMacro("VERSION", "\"1.09\"");
    gfm.addCSourceFiles(.{
        .dependency = upstream,
        .files = &.{
            "gfm/trunk/src/cmdline.c",
            "gfm/trunk/src/ctree.c",
            "gfm/trunk/src/dialog.c",
            "gfm/trunk/src/file.c",
            "gfm/trunk/src/filesel.c",
            "gfm/trunk/src/gui.c",
            "gfm/trunk/src/labels.c",
            "gfm/trunk/src/main.c",
            "gfm/trunk/src/paths.c",
            "gfm/trunk/src/rwgroup.c",
            "gfm/trunk/src/splashscreen.c",
            "gfm/trunk/src/support.c",
            "gfm/trunk/src/tilibs.c",
            "gfm/trunk/src/ungroup.c",
        },
        .flags = &.{},
    });
    for ([_][]const u8{
        "pixmaps", "help", "icons", "glade", "desktop",
    }) |dir| b.installDirectory(.{
        .source_dir = upstream.path(b.pathJoin(&.{
            "gfm", "trunk", dir,
        })),
        .install_dir = .{ .custom = "share" },
        .install_subdir = dir,
    });
    b.installArtifact(gfm);
}
