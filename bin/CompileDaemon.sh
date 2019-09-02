#!/bin/bash

CompileDaemon -h >/dev/null 2>&1 || go get -u github.com/githubnemo/CompileDaemon

CompileDaemon \
	-exclude-dir ".git" \
	-exclude-dir "vendor" \
	-color \
	-build "go build -o _build_hot_reload" \
	-command "./_build_hot_reload"
