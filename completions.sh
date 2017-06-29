_go() {
  cur="${COMP_WORDS[COMP_CWORD]}"
  case "${COMP_WORDS[COMP_CWORD-1]}" in
    "go")
      comms="build clean doc env fix fmt generate get install list run test tool version vet"
      COMPREPLY=($(compgen -W "${comms}" -- ${cur}))
      ;;
    *)
      files=$(find ${PWD} -mindepth 1 -maxdepth 1 -type f -iname "*.go" -exec basename {} \;)
      dirs=$(find ${PWD} -mindepth 1 -maxdepth 1 -type d -not -name ".*" -exec basename {} \;)
      repl="${files} ${dirs}"
      COMPREPLY=($(compgen -W "${repl}" -- ${cur}))
      ;;
  esac
  return 0
}
complete -F _go go goapp

_aeremote()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="-host -port -dump -load -pretty -batch-size -debug"

  if [[ ${prev} == -*load ]]; then
    COMPREPLY=( $(compgen -f -- ${cur}) )
  elif [[ ${prev} == -*port ]]; then
    COMPREPLY=( $(compgen -W "80 443" -- ${cur}) )
  else
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  fi
}
complete -F _aeremote aeremote aeremote.sh
