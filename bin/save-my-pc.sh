#!/bin/bash

#TODO (filipenos) verificar o mimetype
#se começar com inode inode/directory é um diretório, qualquer outra coisa que começar com inode deve dar erro
#qualquer outra coisa deve ser um arquivo, então pensar em uma forma de sincronizar

#TODO (filipenos) verificar se um diretório já esta sendo sincronizado com o pai
#por exemplo, existe /home/filipe/Documentos, se tentar adicionar /home/filipe/Documentos/Planilhas deve retornar erro pois
#o diretorio acima já esta sendo salvo

#TODO (filipenos) permitir salvar na amazon s3, e falar o nome do bucket, talvez com um arquivo de configuração


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
  if [ -z $1 ]; then
    log "[ERROR] empty"
    exit 1
  fi
}

check_file_exists() {
  is_empty $1
  if [ ! -f $1 ]; then
    log "[ERROR] File $1 not exists"
    exit 1
  fi
}

check_path_exists() {
  is_empty $1
  if [ ! -d $1 ]; then
    log "[ERROR] Path $1 not exists"
    exit 1
  fi
}

add_path() {
  log "Add $1 to save"
  check_path_exists $1
  dir=$(dirname "${1}")
  file="$dir/$file"$(basename "${1}")
  grep -q -s "$file" $FILE_WITH_PATHS
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

mime_type() {
  mimetype --output-format "%m" examples.desktop
}

save_my_pc() {
  check_dependencies
  check_file_exists $FILE_WITH_PATHS

  log "Saving pc data to $PC_NAME"
  while read l;
  do
    dir=$(basename $l)
    log "Saving path $dir"
    check_path_exists "$l"
    gsutil -m rsync -d -r "$l" "gs://$BUCKET_NAME/$pcname/$dir"
  done < $FILE_WITH_PATHS
}

if [ $# -eq 0 ]; then
  print_help
fi

while [ $# -gt 0 ]; do
  case "$1" in
    add)
      shift
      add_path $1
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
