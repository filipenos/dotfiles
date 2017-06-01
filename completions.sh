_go()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "build clean doc env fix fmt generate get install list run test tool version vet" -- $cur) )
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
  else
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  fi
}
complete -F _aeremote aeremote aeremote.sh
