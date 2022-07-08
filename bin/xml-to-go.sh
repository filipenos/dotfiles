#!/bin/bash

zek --version >/dev/null 2>&1 || go install github.com/miku/zek/cmd/zek@latest

zek "$@"
