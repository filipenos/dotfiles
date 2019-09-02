#!/bin/bash

#TODO (filipenos) !importante, ao baixar um pc, remover a permissão de escrita de todos os arquivos e pastas

#TODO (filipenos) permitir salvar na amazon s3, e falar o nome do bucket, talvez com um arquivo de configuração

#TODO (filipenos) permitir não apagar os arquivos, sempre adicionar, talvez ser o padrão

#TODO (filipenos) permitir apagar um diretório que foi removido ou fazer um re-sync apagando o que não é pra sincronizar

#TODO (filipenos) permitir alterar o nome do pc

#TODO (filipenos) permitir selecionar um diretorio para copiar os arquivos, ou usar a home (nesse caso a opcao -d 'apagar' é perigosa pq pode apgar tudo
#com opção de apagar local, ou manter
#save-my-pc.sh get <path-to-save> ou <atualizar_diretorios_locais>

#TODO (filipenos) ignorar diretorios de projetos git por padrão, adicionar uma flag para forçar sincronizar
#inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
#if [ "$inside_git_repo" ]; then
  #echo "inside git repo"
#else
  #echo "not in git repo"
#fi

FILE_WITH_PATHS=$HOME/.savemypc
BUCKET_NAME=filipenos


test $(uname -s) = "Darwin"
if [ $? -eq 0 ]; then
  PC_NAME=$(scutil --get LocalHostName)
else
  PC_NAME=$(cat /etc/hostname)
fi

log() {
  echo "[SAVE-MY-PC]" $@
}

print_help() {
  echo "Usage $1 (add|show|show-remote|save|get)"
  exit 1
}

is_empty() {
  if [ -z "$1" ]; then
    shift
    log "[ERROR] empty" $@
    exit 1
  fi
}

check_exists() {
   is_empty "$1"
  if [ ! -e "$1" ]; then
    log "[ERROR] File/Path $1 not exists"
    exit 1
  fi
}

add() {
  if [ ! -e "$1" ]; then
    log "[ERROR] $1 not exists"
    exit 1
  fi

  typ=$(file --mime-type -b "$1")
  if [ $typ == "inode/directory" ]; then
    add_path "$1"
    exit 0
#  else
#    echo $typ | grep -q -s -e "text/"
#    if [ $? -eq 0 ]; then
#      add_file "$1"
#      exit 0
#    fi
  fi
  log "[ERROR] Current type $typ is not supported"
  exit 1
}

add_path() {
  to_add=$(realpath "$1")
  log "Add $to_add to save"
  check_exists "$to_add"
  typ=$(file --mime-type -b "$to_add")
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
    echo $file >> $FILE_WITH_PATHS
    log "Path added successfully!"
  else
    log "[ERROR] Path already added"
  fi
}

add_file() {
  to_add=$(realpath "$1")
  log "Add file $to_add to save"
  check_exists "$1"
  grep -q -s -e "$to_add" $FILE_WITH_PATHS
  if [ $? -eq 0 ]; then
    log "[ERROR] file already added"
    exit 1
  fi
  echo "$to_add" >> $FILE_WITH_PATHS
  log "File added successfully!"
}

show_paths() {
  log "Listing paths to save remote"
  check_exists $FILE_WITH_PATHS
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
  check_exists $FILE_WITH_PATHS

  log "Saving pc data to $PC_NAME"
  while read l;
  do
    check_exists "$l"
    to_save=$(echo "$l" | sed 's,'"$HOME/"',,g')
    log "Saving $to_save"
    gsutil -m rsync -d -r "$l" "gs://$BUCKET_NAME/$PC_NAME/$to_save"
  done < $FILE_WITH_PATHS
}

get_my_pc() {
  check_dependencies
  pc=$(echo "$1" | sed -e 's/^[[:space:]]*//')
  is_empty "$pc" "Get command required pc name"

  log "Getting files from pc $pc"
  gsutil ls "gs://$BUCKET_NAME/$pc" 2> /dev/null
  if [ $? -gt 0 ]; then
    log "[ERROR] No files from $pc"
    exit 1
  fi

  if [ ! -d "$HOME/$pc" ]; then
    log "Creating home pc $pc dir"
    mkdir "$HOME/$pc"
  fi

  gsutil -m rsync -d -r "gs://$BUCKET_NAME/$pc" "$HOME/$pc" #option -d are dangeurs
}

if [ $# -eq 0 ]; then
  print_help
fi

while [ $# -gt 0 ]; do
  case "$1" in
    add)
      shift
      add "$1"
      ;;
    get)
      shift
      get_my_pc "$1"
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
