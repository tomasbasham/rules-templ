"""templ actions."""

load("@bazel_skylib//lib:shell.bzl", "shell")

def templ_generate(ctx, src, out):
    """Generates a file using templ.

    Args:
        ctx: The context.
        src: The source file to generate from.
    """
    command = templ_command_line(
        executable = ctx.executable._templ_tool.path,
        src = src.path,
        out = out.path,
    )

    ctx.actions.run_shell(
        tools = [ctx.executable._templ_tool],
        inputs = [src],
        outputs = [out],
        command = command,
        mnemonic = "TemplGenerate",
        use_default_shell_env = True,
    )

def templ_command_line(executable, src, out):
    """Formats the command line to call templ with the given arguments.

    Args:
        executable: The templ executable.
        src: The source file to generate from.
        out: The output file to generate.

    Returns:
        A command to invoke templ.
    """
    return "{templ} generate -f {src} -stdout $@ > {out}".format(
        templ = shell.quote(executable),
        src = shell.quote(src),
        out = shell.quote(out),
    )
