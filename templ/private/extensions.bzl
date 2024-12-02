load("//templ/private:binary.bzl", "templ_download_binary_rule")

_download_tag = tag_class(
    attrs = {
        # Currently this attributue is not used, but it is here to allow for
        # future expansion.
        "version": attr.string(
            doc = "The version of the binary to download",
            default = "v0.2.793",
        ),
    },
)

def _templ_dependencies_impl(ctx):
    """
    Module extension to set up platform-specific binary dependencies
    """
    for module in ctx.modules:
        if len(module.tags.download) > 1:
            fail("templ.download: only one version can be specified per module")

        for download in module.tags.download:
            # downloads without an explicit version are fetched even when not
            # selected by toolchain resolution. This is acceptable if brought in
            # by the root module, but transitive dependencies should not slow
            # down the build in this way.
            if not module.is_root or not download.version:
                fail("templ.download: version must be specified in non-root module " + module.name)

            # Register the binary download for the current platform
            templ_download_binary_rule(
                name = "templ_binary",
                version = download.version,
            )

templ = module_extension(
    implementation = _templ_dependencies_impl,
    tag_classes = {
        "download": _download_tag,
    },
)
