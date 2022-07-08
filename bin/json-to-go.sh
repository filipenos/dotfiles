#!/bin/bash

gojsonstruct -help >/dev/null 2>&1 || go install github.com/twpayne/go-jsonstruct/cmd/gojsonstruct@latest

gojsonstruct "$@"
