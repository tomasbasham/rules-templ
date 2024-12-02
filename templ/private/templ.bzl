"""Rules for generating Go source files from templ files."""

load("@rules_go//go:def.bzl", "GoLibrary", "GoSource")
load("//templ/private:actions.bzl", "templ_generate")

# _TEMPL_TOOL = Label("@templ_binary//:templ.bin")
_TEMPL_TOOL = Label("//templ")

def _templ_generate(ctx, src):
    """Wrapper for templ_generate action.

    Args:
        ctx: The context.
        src: The templ file to generate Go source file from.
    """
    out = ctx.actions.declare_file(
        src.basename.replace(".templ", ".go"),
    )
    templ_generate(ctx, src, out)
    return out

def _templ_library_impl(ctx):
    """Implementation for templ_library rule.

    Args:
        ctx: The context.
    """
    go_srcs = [_templ_generate(ctx, src) for src in ctx.files.srcs]
    return [
        DefaultInfo(files = depset(go_srcs)),
        GoSource(
            srcs = go_srcs,
            deps = ctx.attr.deps,
        ),
    ]

templ_library = rule(
    implementation = _templ_library_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "List of dependencies for the generated Go source files.",
            providers = [GoLibrary],
        ),
        "srcs": attr.label_list(
            doc = "List of templ files to generate Go source files from.",
            allow_files = [".templ"],
            mandatory = True,
        ),
        "_templ_tool": attr.label(
            doc = "The templ tool.",
            default = _TEMPL_TOOL,
            executable = True,
            cfg = "exec",
            mandatory = False,
        ),
    },
    provides = [GoSource],
    doc = "Generates Go source files from templ files.",
)
