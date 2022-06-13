FROM node:lts-alpine3.16
MAINTAINER Andrey Paskal <andrey@paskal.email>

ENV USER node
ENV USER_HOME /home/${USER}

RUN \
  apk add --update --no-cache \
  bash \
  bash-completion \
  bat \
  bzip2 \
  ca-certificates \
  curl \
  dumb-init \
  file \
  fzf \
  gcc g++ make \
  git \
  gnupg \
  grep \
  gzip \
  jq \
  less \
  ncurses-terminfo-base \
  neovim \
  nodejs-current \
  npm \
  openssh \
  perl \
  py3-pynvim \
  python3 \
  rsyslog \
  sudo \
  the_silver_searcher \
  tmux \
  tree \
  unzip \
  util-linux \
  yarn

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

# Install neovim config
RUN git clone  https://github.com/app/nvim.lua.git ${USER_HOME}/.config/nvim
# Install neovim plugin manager 'vim-plug'
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-${USER_HOME}/.local/share}"/nvim/site/autoload/plug.vim \
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# Update files ownership
RUN chown -R ${USER}:${USER} ${USER_HOME}

SHELL ["/bin/bash", "-c"]
USER ${USER}
# Install executables required by neovim plugins
RUN yarn global add \
  create-react-app \
  prettier \
  typescript-language-server \
  typescript \
  diagnostic-languageserver \
  eslint
# Add path to above installed executables
RUN echo export PATH="\$(yarn global bin):\$PATH" >> ${USER_HOME}/.bashrc

WORKDIR ${USER_HOME}
# Install neovim plugins with vim-plug manager command PlugInstall
RUN nvim --headless +PlugInstall +qall 2> ${USER_HOME}/error.log
COPY start.sh ${USER_HOME}
COPY .gitconfig ${USER_HOME}
COPY .bash_prompt ${USER_HOME}
COPY .bash_profile ${USER_HOME}
COPY .bash_git ${USER_HOME}
COPY .tmux.conf ${USER_HOME}
COPY .tmux_statusline ${USER_HOME}

USER root
# Add 'vim' command alias
RUN ln -s /usr/bin/nvim /usr/bin/vim
RUN chown $USER.$USER start.sh .gitconfig .bash_prompt .bash_profile .bash_git \
      .tmux.conf .tmux_statusline
ENTRYPOINT ["/home/node/start.sh"]
