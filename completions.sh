_go()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "build clean doc env fix fmt generate get install list run test tool version vet" -- $cur) )
}
complete -F _go go
complete -F _go goapp

_aeremote()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "-host -port -dump -load -pretty -batch-size -debug" -- $cur) )
}
complete -F _aeremote aeremote
complete -F _aeremote aeremote.sh
