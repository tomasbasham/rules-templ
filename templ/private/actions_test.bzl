"""Unit tests for templ actions."""

load("@bazel_skylib//lib:unittest.bzl", "asserts", "unittest")
load("//templ/private:actions.bzl", "templ_command_line")

def _templ_command_line_impl(ctx):
    env = unittest.begin(ctx)
    asserts.equals(
        env,
        "'/path/to/templ' generate -f '/path/to/input.templ' -stdout $@ > '/path/to/output.go'",
        templ_command_line(
            "/bin/templ",
            "mysource.templ",
            "/dir/myoutput.go",
        ),
    )
    return unittest.end(env)

templ_command_line_test = unittest.make(_templ_command_line_impl)

def actions_test_suite():
    unittest.suite(
        "actions_tests",
        templ_command_line_test,
    )
