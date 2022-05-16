#!/bin/bash
# Stop on errors
set -e
# Default user is node
[ -n "$USERID" ] || USERID=`id -u node`

# Switch to user with same UID as host user; Create user if needed
if ( grep ":$USERID:" /etc/passwd > /dev/null  ); then
  UNAME=` grep ":$USERID:" /etc/passwd| awk -F ':' '{print $1}'|head -n1`
else
  UNAME=condev
  adduser --uid $USERID --disabled-password --gecos "" $UNAME
fi

copy_files ()
{
  if [[ ! "$UNAME" == "node" ]]; then
    COPY=cp
    USER_HOME="/home/$UNAME"
    [[ "$UNAME" -eq "root" ]] && USER_HOME="/root"
    mkdir -p "${USER_HOME}/.config"
    mkdir -p "${USER_HOME}/.local/share/nvim/site/autoload"
    cd /home/node
    $COPY .local/share/nvim/site/autoload/plug.vim \
      "${USER_HOME}/.local/share/nvim/site/autoload/plug.vim"
    $COPY -r .config/nvim "${USER_HOME}/.config/"
    $COPY .gitconfig "${USER_HOME}"
    $COPY .bash_prompt "${USER_HOME}"
    $COPY .bash_profile "${USER_HOME}"
    $COPY .bash_git "${USER_HOME}"
    $COPY .tmux.conf "${USER_HOME}"
    $COPY .tmux_statusline "${USER_HOME}"
    echo "alias ll='ls -l'" >> ${USER_HOME}/.bashrc && \
      echo "alias la='ls -la'" >> ${USER_HOME}/.bashrc && \
      echo "alias vim='nvim'" >> ${USER_HOME}/.bashrc && \
      echo ". ~/.bash_prompt" >> ${USER_HOME}/.bashrc && \
      echo ". ~/.bash_git" >> ${USER_HOME}/.bashrc && \
      echo ". ~/.bash_locale" >> ${USER_HOME}/.bashrc && \
      sed -i '1iexport TERM=xterm-256color' ${USER_HOME}/.bashrc

    echo 'export LANG="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
      echo 'export LC_ALL="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
      echo 'export LANGUAGE="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale

    cd "${USER_HOME}"
    chown -R $UNAME .gitconfig .bash_prompt .bash_profile .bash_git \
      .tmux.conf .tmux_statusline .local/share/nvim .config/nvim
  fi
}

# Default values
[ -n "$TERM" ] || TERM="xterm-256color"
[[ "$TERM" == "xterm" ]] && TERM="xterm-256color"
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
  copy_files
  su -s /bin/bash -c "$VARS tmux -u new-session -s condev -c /bin/bash" - $UNAME
  # echo "exiting ...1"
  # pwd
  # id
fi

