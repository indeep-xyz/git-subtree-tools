#!/bin/bash

# variables
MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
DEST_NAME="init-gitstt"
DEST_PATH="/usr/local/bin/$DEST_NAME"

# install
ln -s "$MY_DIR/init-tools.sh" "$DEST_PATH"

# message
[ $? -eq 0 ] && echo "installed to $DEST_PATH"
