main() {
HOME=$(cd ; pwd)
SCRIPTS0_SYS=$HOME/bashlauncher
SCRIPTS0=$SCRIPTS0_SYS/_
SCRIPTS=$HOME/bin

#first, make symlink
if [ ! -d "$SCRIPTS" ]; then
	rm $SCRIPTS 2> /dev/null # remove symlink only
	mkdir -p $SCRIPTS0
	ln -sfv $SCRIPTS0 $SCRIPTS
fi

#=== includes
#source $SCRIPTS0_SYS/utils.sh

#update user's home
USER_INITER=". $SCRIPTS0_SYS/init.sh"
#grep -qxF "$USER_INITER" ~/.profile || echo "$USER_INITER" >> ~/.profile
grep -qxF "$USER_INITER" ~/.bashrc || echo "$USER_INITER" >> ~/.bashrc

#add scripts dir to PATH
pathadd $SCRIPTS

#autocomplete
bind 'set completion-display-width 0'
complete -o nospace -F _complete x

#aliases
aliases

echo init finished
}

aliases() {
	alias c="clear"
	alias x0="cd $SCRIPTS0_SYS"
	alias lx="ls -al $SCRIPTS/"
	#Bash launcher - update
	alias blup="(cd $SCRIPTS0_SYS; echo Current DIR=$PWD; echo Pulling changes ...; git pull; echo -e \"Committing and Pushing started\"; git add .; git commit -am 'updated scripts'; git push origin master; echo -e \"\n\nPush Complete!\")"
}

pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1" ; export PATH
        echo "added to PATH => $PATH"
    fi
}

x() {
  if [ ! $# -eq 0 ]; then
	$@
  else
	cd $SCRIPTS
  fi
}

_complete() {
  _complete0 "$SCRIPTS"
}

_complete0() {
  # declare variables
  local _item _COMPREPLY _old_pwd

  # if we already are in the completed directory, skip this part
  if [ "${PWD}" != "$1" ]; then
    _old_pwd="${PWD}"
    # magic here: go the specific directory!
    pushd "$1" &>/dev/null || return

    # init completion and run _filedir inside specific directory
    _init_completion -s || return
    _filedir

    # iterate on original replies
    for _item in "${COMPREPLY[@]}"; do
      # this check seems complicated, but it handles the case
      # where you have files/dirs of the same name
      # in the current directory and in the completed one:
      # we want only one "/" appended
      if [ -d "${_item}" ] && [[ "${_item}" != */ ]] && [ ! -d "${_old_pwd}/${_item}" ]; then
        # append a slash if directory
        _COMPREPLY+=("${_item}/")
      else
        _COMPREPLY+=("${_item}")
      fi
    done

    # popd as early as possible
    popd &>/dev/null

    # if only one reply and it is a directory, don't append a space
    # (don't know why we must check for length == 2 though)
    if [ ${#_COMPREPLY[@]} -eq 2 ]; then
      if [[ "${_COMPREPLY}" == */ ]]; then
        compopt -o nospace
      fi
    fi

    # set the values in the right COMPREPLY variable
    COMPREPLY=( "${_COMPREPLY[@]}" )

    # clean up
    unset _COMPREPLY
    unset _item
  else
    # we already are in the completed directory, easy
    _init_completion -s || return
    _filedir
  fi
}

main "$@"
