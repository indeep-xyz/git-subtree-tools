#!/bin/bash

# basics
MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
MY_NAME="init-git-subtree"
MY_VERSION="1.0"

# optinable variables
DIR_PREFIX=subtree
REMOTE_PREFIX=subtree_

# others
SRC_DIR="$MY_DIR/src"

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
# functions
# {{{1

# - help
# {{{2

echo_help() { # {{{5

  cat <<EOT
$MY_NAME ($MY_VERSION)

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
    script type for initialize
    all|pull|add

    default value is all

EOT
} # }}}5

# }}}2 - help

# - initialize
# {{{2

init() {
  mkdir -p "$DIR_PREFIX"

  if [ -n "$OPT_INIT" ] && [ "$OPT_INIT" != "all" ]; then
    eval "init_$OPT_INIT"
  else
    init_all
  fi
}

init_all() { # {{{5

  for act in add pull push
  do
    eval "init_$act"
  done
} # }}}5

init_add() { # {{{5

  local filename="add.sh"
  local output="$DIR_PREFIX/$filename"

  if check_initializable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

init_pull() { # {{{5

  local filename="pull.sh"
  local output="$DIR_PREFIX/$filename"

  if check_initializable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

init_push() { # {{{5

  local filename="push.sh"
  local output="$DIR_PREFIX/$filename"

  if check_initializable "$output" -eq 0; then
    read_source "$filename" > "$output"
    chmod +x "$output"
  fi
} # }}}5

# }}}2 - initilize

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
# check initializable by arguments
#
# args
# $1 ... output path
#
# returner
# 0 ... initializable
# 1 ... not initializable
check_initializable() { # {{{5

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

init

# }}}1 main
