#!/bin/bash

#TODO (filipenos) permitir adicionar arquivo

#TODO (filipenos) permitir salvar na amazon s3, e falar o nome do bucket, talvez com um arquivo de configuração

#TODO (filipenos) permitir não apagar os arquivos

#TODO (filipenos) permitir apagar um diretório que foi removido


FILE_WITH_PATHS=$HOME/.savemypc
BUCKET_NAME=filipenos
PC_NAME=$(cat /etc/hostname)

log() {
  echo "[SAVE-MY-PC]" $@
}

print_help() {
  echo "Usage $1 (add|show|show-remote|save)"
  exit 1
}

is_empty() {
  if [ -z "$1" ]; then
    log "[ERROR] empty"
    exit 1
  fi
}

check_file_exists() {
  is_empty "$1"
  if [ ! -f "$1" ]; then
    log "[ERROR] File $1 not exists"
    exit 1
  fi
}

check_path_exists() {
  is_empty "$1"
  if [ ! -d "$1" ]; then
    log "[ERROR] Path $1 not exists"
    exit 1
  fi
}

add_path() {
  to_add=$(realpath "$1")
  #to_add="$1"
  log "Add $to_add to save"
  check_path_exists "$to_add"
  typ=$(mimetype --output-format "%m" "$to_add")
  if [ $typ != "inode/directory" ]; then
    log "[ERROR] Current type $typ is not supported"
    exit 1
  fi

  p=$(dirname "$to_add")
  while [ "$p" != "/" ]; do
    grep -q -s -e "$p\$" $FILE_WITH_PATHS
    if [ $? -eq 0 ]; then
      log "[ERROR] parent directory already added"
      exit 1
    fi
    p=$(dirname $p)
  done

  dir=$(dirname "$to_add")
  file="$dir/"$(basename "$to_add")
  grep -q -s -e "$file\$" $FILE_WITH_PATHS
  if [ $? -gt 0 ]; then
    log "Path added successfully!"
    echo $file >> $FILE_WITH_PATHS
  else
    log "[ERROR] Path already added"
  fi
}

show_paths() {
  log "Listing paths to save remote"
  check_file_exists $FILE_WITH_PATHS
  cat $FILE_WITH_PATHS
}

show_remote() {
  log "Listing paths on remote bucket"
  gsutil ls "gs://$BUCKET_NAME/$PC_NAME/"
}

check_dependencies() {
  log "Check if dependencies are instaled"
  which gsutil > /dev/null
  if [ $? -gt 0 ]; then
    log "[ERROR] gsutil command not found"
    exit 1
  fi
}

save_my_pc() {
  check_dependencies
  check_file_exists $FILE_WITH_PATHS

  log "Saving pc data to $PC_NAME"
  while read l;
  do
    check_path_exists "$l"
    dir=$(echo "$l" | sed 's,'"$HOME/"',,g')
    log "Saving path $dir"
    gsutil -m rsync -d -r "$l" "gs://$BUCKET_NAME/$PC_NAME/$dir"
  done < $FILE_WITH_PATHS
}

if [ $# -eq 0 ]; then
  print_help
fi

while [ $# -gt 0 ]; do
  case "$1" in
    add)
      shift
      add_path "$1"
      ;;
    show)
      show_paths
      ;;
    show-remote)
      show_remote
      ;;
    save)
      save_my_pc
      ;;
    -h|--help|help|*)
      print_help
      ;;
  esac
  shift
done
