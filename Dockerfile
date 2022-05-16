FROM node:current-alpine
MAINTAINER Andrey Paskal <andrey@paskal.email>

ENV USER node
ENV USER_HOME /home/${USER}

RUN \
  apk add --update --no-cache \
  ncurses-terminfo-base \
  bash \
  bash-completion \
  util-linux \
  unzip \
  bzip2 \
  ca-certificates \
  curl \
  file \
  grep \
  gzip \
  rsyslog \
  dumb-init \
  sudo \
  git \
  tmux \
  jq \
  tree \
  less \
  nodejs-current \
  npm \
  yarn \
  openssh \
  the_silver_searcher \
  python3 \
  py3-pynvim \
  gnupg \
  gcc g++ make \
  perl

# Install dependencies for building neovim package
# from sources with APKBUILD file
# RUN \
#   apk add --update --no-cache \
#   alpine-sdk
# RUN addgroup condev abuild

# RUN adduser --disabled-password --gecos "" ${USER}
# RUN echo "${USER} ALL=NOPASSWD: ALL" >>  /etc/sudoers.d/11-node.conf && chmod 440 /etc/sudoers.d/11-node.conf
COPY ./alpine-3.15/.abuild/condev-627fa37a.rsa.pub /etc/apk/keys/
COPY ./alpine-3.15/packages /home/condev/packages
RUN apk add /home/condev/packages/condev/x86_64/neovim-*.apk

RUN echo "alias ll='ls -l'" >> ${USER_HOME}/.bashrc && \
  echo "alias la='ls -la'" >> ${USER_HOME}/.bashrc && \
  echo "alias vim='nvim'" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_prompt" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_git" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_locale" >> ${USER_HOME}/.bashrc && \
  sed -i '1iexport TERM=xterm-256color' ${USER_HOME}/.bashrc

RUN echo 'export LANG="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
  echo 'export LC_ALL="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
  echo 'export LANGUAGE="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale

RUN git clone  https://github.com/app/nvim.lua.git ${USER_HOME}/.config/nvim
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-${USER_HOME}/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN chown -R ${USER}:${USER} ${USER_HOME}

SHELL ["/bin/bash", "-c"]
USER ${USER}
RUN yarn global add \
  create-react-app \
  prettier \
  typescript-language-server \
  typescript \
  diagnostic-languageserver \
  eslint
RUN echo export PATH="\$(yarn global bin):\$PATH" >> ${USER_HOME}/.bashrc

WORKDIR ${USER_HOME}
RUN nvim --headless +PlugInstall +qall 2> ${USER_HOME}/error.log
# RUN /bin/bash -c '[ -f ~/.fzf.bash ] && source ~/.fzf.bash'
COPY start.sh ${USER_HOME}
COPY .gitconfig ${USER_HOME}
COPY .bash_prompt ${USER_HOME}
COPY .bash_profile ${USER_HOME}
COPY .bash_git ${USER_HOME}
COPY .tmux.conf ${USER_HOME}
COPY .tmux_statusline ${USER_HOME}

USER root
RUN chown $USER.$USER start.sh .gitconfig .bash_prompt .bash_profile .bash_git \
      .tmux.conf .tmux_statusline
ENTRYPOINT ["/bin/bash","-c"]
# CMD ["tmux -u new-session -s condev"]
CMD ["/home/node/start.sh"]
