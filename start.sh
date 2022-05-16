#!/bin/bash
# Stop on errors
set -e
# Switch to user with same UID as host user; Create user if needed
if ( id -un "$USERID" >/dev/null 2>&1 ); then
  UNAME =`id -un "$USERID"`
else
  adduser --uid $USERID --gid $USERID --disabled-password --gecos "" condev
fi
su $UNAME -

if [ $# -gt 0 ]; then
  exec "$@"
else
  exec "tmux -u new-session -s condev"
fi

