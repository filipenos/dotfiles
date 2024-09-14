#!/bin/bash


# Download the Visual Studio Code CLI
# https://code.visualstudio.com/docs/remote/tunnels#_using-the-code-cli

# MacOS silicon
curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-darwin-x64' --output vscode_cli.tar.gz

tar -xf vscode_cli.tar.gz