docker run \
  --rm \
  -it \
  --name "coder" \
  -p 127.0.0.1:8080:8080 \
  -e PASSWORD=filipe \
  -v "$PWD:/home/coder/project" \
  -v "$HOME/dotfiles/vscode/settings.json:/User/settings.json" \
  codercom/code-server
