def _templ_download_binary_rule_impl(ctx):
    """
    Repository rule to download platform-specific binaries
    """

    # Define download URLs for different platforms
    platform_binaries = {
        "darwin-arm64": {
            "url": "https://github.com/a-h/templ/releases/download/v0.2.793/templ_Darwin_arm64.tar.gz",
            "sha256": "2905abb33767ca72d9ee85f4cbee597dc2334e2c49a2280f1c7357b36ca5f64a",
        },
        "darwin-amd64": {
            "url": "https://github.com/a-h/templ/releases/download/v0.2.793/templ_Darwin_x86_64.tar.gz",
            "sha256": "2bb7ef6ff68a58c7a65f6c807509a1eb176445c40b6d1b959513a3e1507747a3",
        },
        "linux-arm64": {
            "url": "https://github.com/a-h/templ/releases/download/v0.2.793/templ_Linux_arm64.tar.gz",
            "sha256": "09f6f6fefe49d3072ae6b411d9466f30afab7d8c1c36d064e402d40f85e4deb7",
        },
        "linux-amd64": {
            "url": "https://github.com/a-h/templ/releases/download/v0.2.793/templ_Linux_x86_64.tar.gz",
            "sha256": "34fe42749e37604ef34118a6c3723c79f9bfc4301f9167dc0bbd4d6655fad562",
        },
        "windows-amd64": {
            "url": "https://example.com/binary-windows-x64.exe",
            "sha256": "fac1f27a6c3c5e63cb6fa6b88885523f9fcd63bb99447dd5a0dd2acc9c27942d",
        },
    }

    # Determine the current platform
    os_name = ctx.os.name

    # Construct platform key
    platform_key = "{os_name}-{arch}".format(
        os_name = os_name,
        arch = ctx.os.arch,
    )

    # Select the appropriate binary
    if platform_key not in platform_binaries:
        fail("Unsupported platform: {}".format(platform_key))

    binary_info = platform_binaries[platform_key]
    templ_binary = "templ"

    # Download and extract to a predictable, platform-independent location
    ctx.download_and_extract(
        url = binary_info["url"],
        sha256 = binary_info["sha256"],
    )

    # Make the binary executable
    if os_name != "windows":
        ctx.execute(["chmod", "+x", templ_binary])

    # Create a BUILD file to expose the binary
    ctx.file(
        "BUILD.bazel",
        """
filegroup(
    name = "templ.bin",
    srcs = ["{templ_binary}"],
    visibility = ["//visibility:public"],
)
    """.format(
            templ_binary = templ_binary,
        ),
    )

templ_download_binary_rule = repository_rule(
    implementation = _templ_download_binary_rule_impl,
    attrs = {
        "version": attr.string(mandatory = True),
    },
)
