#!/bin/bash
# Stop on errors
set -e
# Default user is node
[ -n "$USERID" ] || USERID=`id -u node`

# Switch to user with same UID as host user; Create user if needed
if ( grep ":$USERID:" /etc/passwd > /dev/null  ); then
  UNAME=` grep ":$USERID:" /etc/passwd| awk -F ':' '{print $1}'`
else
  UNAME=condev
  adduser --uid $USERID --disabled-password --gecos "" $UNAME
fi

# Default values
[ -n "$TERM" ] || TERM="xterm-256color"
[ -n "$GIT_COMMITTER_NAME" ] || GIT_COMMITTER_NAME="app"
[ -n "$GIT_AUTHOR_NAME" ] || GIT_AUTHOR_NAME="Andrey Paskal"
[ -n "$EMAIL" ] || EMAIL="andrey@paskal.email"
[ -n "$D" ] || D="D1"
[ -n "$DD" ] || DD="DD1"

VARS="\
  TERM=\"$TERM\" \
  GIT_COMMITTER_NAME=\"${GIT_COMMITTER_NAME}\" \
  GIT_AUTHOR_NAME=\"${GIT_AUTHOR_NAME}\" \
  EMAIL=\"$EMAIL\" \
  USERID=\"$USERID\" \
  SSH_AUTH_SOCK=\"$SSH_AUTH_SOCK\" \
"

if [ $# -gt 0 ]; then
  su -s /bin/bash -c "$VARS $@" - $UNAME
else
  su -s /bin/bash -c "$VARS tmux -u new-session -s condev" - $UNAME
fi

