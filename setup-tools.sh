#!/bin/bash

# basics
MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
MY_NAME="setup-tools"
MY_VERSION="1.0"

# optinable variables
DIR_PREFIX=subtree
REMOTE_PREFIX=subtree_

# others
SRC_DIR="$MY_DIR/src"

# - - - - - - - - - - - - - - - - - - - -
# functions
# {{{1

# - help
# {{{2

echo_help() { # {{{5

  cat <<EOT
$MY_NAME ($MY_VERSION)

setup git-subtree-tools for each Git project.

Usage:
  $MY_NAME [Options] [GIT_ROOT_DIR]

  require to run in git root directory.
  if not exists ./.git directory, error and exit.

  GIT_ROOT_DIR
    path for root directory of Git project
    default value is '.'

Options:
  -d
    directory string for \`git subtree --prefix=**\`.
    default value is 'subtree'.

  -f
    force to initialize
    if set, overwrite script file

  -r
    remote name's prefix for subtree.
    default value is 'subtree_'

  -h
  -?
    display help message

  -t type
    script type for setup
    all|add|pull|push

    default value is all

EOT
} # }}}5

# }}}2 - help

# - setup
# {{{2

setup() {
  mkdir -p "$DIR_PREFIX"

  if [ -n "$OPT_INIT" ] && [ "$OPT_INIT" != "all" ]; then
    eval "setup_$OPT_INIT"
  else
    setup_all
  fi
}

setup_all() { # {{{5

  for act in add pull push
  do
    eval "setup_$act"
  done
} # }}}5

setup_add() { # {{{5

  local filename="add.sh"
  local output="$DIR_PREFIX/$filename"

  if check_writable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

setup_pull() { # {{{5

  local filename="pull.sh"
  local output="$DIR_PREFIX/$filename"

  if check_writable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

setup_push() { # {{{5

  local filename="push.sh"
  local output="$DIR_PREFIX/$filename"

  if check_writable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

# }}}2 - setup

# - other
# {{{2

read_source() { # {{{5

  root_dir="`make_root_dir_string`"

  cat "$SRC_DIR/$1" \
      | sed -e "s,!!!ROOT_DIR!!!,$root_dir,g" \
            -e "s,!!!DIR_PREFIX!!!,$DIR_PREFIX,g" \
            -e "s,!!!REMOTE_PREFIX!!!,$REMOTE_PREFIX,g" \
            -e "s,!!!GEN_APP_NAME!!!,$MY_NAME,g" \
            -e "s,!!!GEN_APP_VERSION!!!,$MY_VERSION,g"
} # }}}5

# = =
# check writable
#
# args
# $1 ... output path
#
# returner
# 0 ... writable
# 1 ... not writable
check_writable() { # {{{5

  if [ -e "$1" ] && [ "$OPT_FORCE" != "1" ]; then

    echo "script is already exists! ---> $1"
    return 1
  fi

  return 0
} # }}}5

make_root_dir_string() { # {{{5

  local -i depth=1
  let depth+=$(
    printf "$DIR_PREFIX" \
        | sed -e 's/\/$//' -e 's/[^/]//g' \
        | wc -c
  )

  printf "\\\$MY_DIR"
  while [ $depth -gt 0 ];
  do
    printf "/.."
    let depth--
  done
} # }}}5

# }}}2 - other
# }}}1 functions

# - - - - - - - - - - - - - - - - - - - -
# arguments
# {{{1

# - command options

while getopts d:r:t:fh? OPT
do
  case $OPT in
    d)    DIR_PREFIX="$OPTARG";;
    r)    REMOTE_PREFIX="$OPTARG";;
    t)    OPT_INIT=$OPTARG;;
    f)    OPT_FORCE=1;;
    h|\?) echo_help
          exit 0
          ;;
  esac
done

shift $((OPTIND - 1))

# }}}1 - arguments

# - - - - - - - - - - - - - - - - - - - -
# main
# {{{1

# `cd` to root directory for Git
[ -n "$1" ] && cd "$1"

# check status
git status > /dev/null 2>&1

# guard
# - require initialized by Git
if [ $? -ne 0 ]; then
  echo "error: does not initialized by Git. ---> $PWD"
  exit 1
fi

setup

# }}}1 main
