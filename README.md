Written in OpenGL, dependencies right now:

* GLFW for cross platform window opening, at some point I want to also provide GTK on Linux and (native) on Mac (custom windowing library I presume)
* FreeType

With the exception of native UI (e.g. MacOS status bar), I think everything is probably either going to be a pane or a modal. For panes, entire window = parent, similar to tiling window manager for managing panes like filetree, documents, viewers, terminal emulator, i.e. things that need specific position. (possibly vtables/comptime, need to take a look.) Modals ignore this concept of panes and can float around anywhere, maybe they're pane managers of their own, e.g. popups and command palette.
