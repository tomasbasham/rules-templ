package main

// This file exists to ensure that all dependencies are available to the build
// system. Becuase the templ module itself is not Bazel compatible, when gazelle
// runs, it will not detect the dependencies of the templ binary.
import (
	_ "github.com/PuerkitoBio/goquery"
	_ "github.com/a-h/htmlformat"
	_ "github.com/a-h/parse"
	_ "github.com/a-h/pathvars"
	_ "github.com/a-h/protocol"
	_ "github.com/andybalholm/brotli"
	_ "github.com/cenkalti/backoff/v4"
	_ "github.com/cli/browser"
	_ "github.com/fatih/color"
	_ "github.com/fsnotify/fsnotify"
	_ "github.com/natefinch/atomic"
	_ "github.com/rs/cors"
	_ "go.lsp.dev/jsonrpc2"
	_ "go.lsp.dev/uri"
	_ "go.uber.org/zap"
)
