#!/bin/bash
# Stop on errors
set -e
# Default user is node
[ -n "$USERID" ] || USERID=`id -u node`

# UID mapping
# Switch to container user with host user UID; Create container user if needed
if ( grep ":$USERID:" /etc/passwd > /dev/null  ); then
  UNAME=` grep ":$USERID:" /etc/passwd| awk -F ':' '{print $1}'|head -n1`
else
  UNAME=condev
  adduser --uid $USERID --disabled-password --gecos "" $UNAME
fi

copy_files ()
{
  echo "Detected user name is $UNAME" >> /home/$UNAME/condev.log
  if [[ ! "$UNAME" == "node" ]]; then
    COPY=cp
    UHOME="/home/$UNAME"
    [[ "$UNAME" == "root" ]] && UHOME="/root"
    echo "Start file creation in user's home directory ${UHOME}" >> /home/$UNAME/condev.log
    mkdir -p "${UHOME}/.config"
    mkdir -p "${UHOME}/.local/share/nvim/site/autoload"
    CURDIR=`pwd`
    cd /home/node
    $COPY .local/share/nvim/site/autoload/plug.vim \
      "${UHOME}/.local/share/nvim/site/autoload/plug.vim"
    $COPY -r .config/nvim "${UHOME}/.config/"
    $COPY .gitconfig "${UHOME}"
    $COPY .bash_prompt "${UHOME}"
    $COPY .bash_profile "${UHOME}"
    $COPY .bash_git "${UHOME}"
    $COPY .tmux.conf "${UHOME}"
    $COPY .tmux_statusline "${UHOME}"
    echo "alias ll='ls -l'" >> ${UHOME}/.bashrc && \
      echo "alias la='ls -la'" >> ${UHOME}/.bashrc && \
      echo "alias vim='nvim'" >> ${UHOME}/.bashrc && \
      echo ". ~/.bash_prompt" >> ${UHOME}/.bashrc && \
      echo ". ~/.bash_git" >> ${UHOME}/.bashrc && \
      echo ". ~/.bash_locale" >> ${UHOME}/.bashrc && \
      sed -i '1iexport TERM=screen-256color' ${UHOME}/.bashrc

    echo 'export LANG="en_US.UTF-8"' >> ${UHOME}/.bash_locale && \
      echo 'export LC_ALL="en_US.UTF-8"' >> ${UHOME}/.bash_locale && \
      echo 'export LANGUAGE="en_US.UTF-8"' >> ${UHOME}/.bash_locale

    cd "${UHOME}"
    chown -R $UNAME.$UNAME \
      .bash_git \
      .bash_locale \
      .bash_profile \
      .bash_prompt \
      .bashrc \
      .config \
      .gitconfig \
      .local \
      .tmux.conf \
      .tmux_statusline \
      condev.log
    cd $CURDIR
  fi
}

# Default values if not defined
[ -n "$TERM" ] || TERM="screen-256color"
[[ "$TERM" == "xterm" ]] && TERM="screen-256color"
[ -n "$GIT_COMMITTER_NAME" ] || GIT_COMMITTER_NAME="app"
[ -n "$GIT_AUTHOR_NAME" ] || GIT_AUTHOR_NAME="Andrey Paskal"
[ -n "$EMAIL" ] || EMAIL="andrey@paskal.email"

VARS="\
  TERM=\"$TERM\" \
  GIT_COMMITTER_NAME=\"${GIT_COMMITTER_NAME}\" \
  GIT_AUTHOR_NAME=\"${GIT_AUTHOR_NAME}\" \
  EMAIL=\"$EMAIL\" \
  USERID=\"$USERID\" \
  SSH_AUTH_SOCK=\"$SSH_AUTH_SOCK\" \
  PATH=\"/home/node/.yarn/bin:$PATH\" \
"

CMD="$*"
if [ $# -gt 0 ]; then
  su $UNAME -c "export $VARS; $CMD"
else
  copy_files
  su $UNAME -c "$VARS tmux -u new-session -s condev"
fi

