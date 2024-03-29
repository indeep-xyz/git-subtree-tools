#!/bin/bash

MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
MY_NAME="add.sh"
MY_VERSION="1.0"

ROOT_DIR="!!!ROOT_DIR!!!"
DIR_PREFIX="!!!DIR_PREFIX!!!"
REMOTE_PREFIX="!!!REMOTE_PREFIX!!!"

OPT_SQUASH=" --squash"

# - - - - - - - - - - - - - - - - - - - -
# functions

# - help

echo_help() {
  cat <<EOT
$MY_NAME ($MY_VERSION)
  generated by !!!GEN_APP_NAME!!! (!!!GEN_APP_VERSION!!!)

Usage:
  $MY_NAME [Options] [NAME] [REMOTE_PATH] [BRANCH]

  NAME (require)
    name for Git subtree's name and Git remote repository's name.
    add prefix '$REMOTE_PREFIX' to this string

  REMOTE_PATH (require)
    remote repository's path

  BRANCH
    remote repository's branch name.
    default value is 'master'.

Options:
  -h
  -?
    display help message

  -s
    disable to \`git add --squash\` option
    default is enabled

EOT
}

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
REMOTE_PATH="$2"
BRANCH="${3:-master}"

# - - - - - - - - - - - - - - - - - - - -
# guard

# require arguments
# - $1 (SubtreeName), $2 (SubtreeRemotePath)
if [ -z "$1" ] || [ -z "$2" ]; then

  echo_help
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - -
# main

REMOTE="$REMOTE_PREFIX$NAME"

cd "$ROOT_DIR"
git remote add "$REMOTE" "$REMOTE_PATH"
eval git subtree add $OPT_SQUASH --prefix "$DIR_PREFIX/$NAME" "$REMOTE" "$BRANCH"

