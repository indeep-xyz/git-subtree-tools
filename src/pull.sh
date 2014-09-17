#!/bin/bash

MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
MY_NAME="pull.sh"
MY_VERSION="1.0"

ROOT_DIR="!!!ROOT_DIR!!!"
DIR_PREFIX="!!!DIR_PREFIX!!!"
REMOTE_PREFIX="!!!REMOTE_PREFIX!!!"

OPT_SQUASH=" --squash"

# - - - - - - - - - - - - - - - - - - - -
# arguments

# - command options

while getopts h?s OPT
do
  case $OPT in
    h|\?) echo_help
          exit 0
          ;;
    s)    OPT_SQUASH="";;
  esac
done

shift $((OPTIND - 1))

# - other arguments

NAME="$1"
BRANCH="${2:-master}"

# - - - - - - - - - - - - - - - - - - - -
# functions

# - help

echo_help() {
  cat <<EOT
$MY_NAME ($MY_VERSION)
  generated by !!!GEN_APP_NAME!!! (!!!GEN_APP_VERSION!!!)

Usage:
  $MY_NAME [Options] [NAME] [BRANCH]

  NAME
    name for subtree name.
    if no set, pull all.

  BRANCH
    branch name for remote.
    default value is 'master'.

Options:
  -h
  -?
    display help message

  -s
    disable to \`git push --squash\` option
    default is enabled

EOT
}

# - main features

# = =
# git pull
#
# arguments
# $1 ... subtree's name (suffix of dirname and remote name)
pull() {
  eval git subtree pull $OPT_SQUASH --prefix "$DIR_PREFIX/$1" "$REMOTE_PREFIX$1" "$BRANCH"
}

# = =
# git pull all from same directory
pull_all() {

  for filename in `ls "$DIR_PREFIX"`
  do
    if [ -d "$DIR_PREFIX/$filename" ]; then
      pull "$filename"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - -
# main

cd "$ROOT_DIR"

if [ -n "$NAME" ]; then
  pull "$NAME"
else
  pull_all
fi
