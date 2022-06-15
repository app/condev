FROM node:lts-alpine3.16
MAINTAINER Andrey Paskal <andrey@paskal.email>

ENV USER node
ENV USER_HOME /home/${USER}

RUN \
  apk add --update --no-cache \
  bash \
  bash-completion \
  bat \
  ca-certificates \
  curl \
  fzf \
  gcc g++ \
  git \
  grep \
  gzip \
  jq \
  less \
  make \
  ncurses-terminfo-base \
  neovim \
  nodejs-current \
  npm \
  the_silver_searcher \
  tmux \
  tree \
  unzip \
  util-linux \
  yarn

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

WORKDIR ${USER_HOME}
# Install neovim plugins with vim-plug manager command PlugInstall
RUN nvim --headless +PlugInstall +qall 2> ${USER_HOME}/condev.log
COPY --chown=$USER:$USER start.sh ${USER_HOME}
COPY --chown=$USER:$USER .gitconfig ${USER_HOME}
COPY --chown=$USER:$USER .bash_prompt ${USER_HOME}
COPY --chown=$USER:$USER .bash_profile ${USER_HOME}
COPY --chown=$USER:$USER .bash_git ${USER_HOME}
COPY --chown=$USER:$USER .tmux.conf ${USER_HOME}
COPY --chown=$USER:$USER .tmux_statusline ${USER_HOME}
COPY --chown=$USER:$USER .bash_locale ${USER_HOME}
COPY --chown=$USER:$USER .bashrc ${USER_HOME}

USER root
# Add 'vim' command alias
RUN ln -s /usr/bin/nvim /usr/bin/vim
ENTRYPOINT ["/home/node/start.sh"]
