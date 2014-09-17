#!/bin/bash

# variables
MY_DIR="`readlink -f "$0" | sed 's/\/[^\/]*$//'`"
DEST_NAME="setup-gitstt"
DEST_PATH="/usr/local/bin/$DEST_NAME"

# install
ln -s "$MY_DIR/setup-tools.sh" "$DEST_PATH"

# message
[ $? -eq 0 ] && echo "installed to $DEST_PATH"
