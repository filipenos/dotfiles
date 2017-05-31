contains() {
  case "$1" in
    *${2}*)
      return 0
      ;;
  esac
  return 1
}

if [ -f "$HOME/.custompath" ]; then
  while read l ; do
    if contains "$PATH" ":$l"; then
      echo "alreay add $l"
    else
      export PATH="$PATH:$l"
    fi
  done < "$HOME/.custompath"
fi
