#!/usr/bin/env bash

__bdsm_bash_completion()
{
  local current_word previous flags commands extensions

  COMPREPLY=()
  current_word="${COMP_WORDS[COMP_CWORD]}"
  previous="${COMP_WORDS[COMP_CWORD-1]}"
  extensions="$( bdsm list | tr "\n" ' ')"
  commands="extend help get list version mod edit open website ${extensions}"
  commands="${commands[@]}"
  flags="--trace"
  current_count=${#COMP_WORDS[@]}
  completed=${COMP_CWORD}

  # Try to complete commands
  if (( current_count >= 1 )) && [[ "${previous}" != -* ]]
  then
    COMPREPLY=( $(compgen -W "${commands}" -- ${current_word}) )
  fi

  if (( current_count >= 2 )) && [[ "${previous}" != -* ]]
  then
    # Complete based on installed extensions.
    case "${previous}" in
      extend)
        available="$( bdsm list available)"
        COMPREPLY=($(compgen -W "${available}" -- ${current_word}))
        return 0
        ;;
      edit|open|website)
        COMPREPLY=( $(compgen -W "${extensions}" -- ${current_word}) )
        return 0
        ;;
      list)
        COMPREPLY=( $(compgen -W "installed available" -- ${current_word}) )
        return 0
        ;;
      *)
        if [[ "${commands}" == *${previous}* ]]
        then
          actions="$( bdsm "${previous}" | tail -1 )"
          COMPREPLY=( $(compgen -W "${actions}" -- ${current_word}) )
          return 0
        fi
        ;;
    esac
  fi

  if (( current_count > 3 ))
  then
    if [[ ${current_word} == -* ]] ; then
      COMPREPLY=( $(compgen -W "${flags}" -- ${current_word}) )
    else
      actions="$( bdsm "${previous}" | tail -1 )"
      COMPREPLY=( $(compgen -W "${actions}" -- ${current_word}) )
    fi
  fi

  # Try to complete options
  if [[ ${current_word} == -* ]] ; then
    COMPREPLY=( $(compgen -W "${flags}" -- ${current_word}) )
    return 0
  else
    COMPREPLY=( $(compgen -W "${commands}" -- ${current_word}) )
    return 0
  fi
}

complete -F __bdsm_bash_completion bdsm

