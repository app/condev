# condev

Ready to use Alpine Linux Node.js Docker container for full stack React/Node.js
applications development with opinionated Neovim code editor LSP Lua setup

### Usage

You can run this image with docker command

```bash
# Lets make alias condev first
alias condev='docker run -it --rm \
  -h condev \
  -p 127.0.0.1:3000:3000/tcp \
  -p 127.0.0.1:3080:3080/tcp \
  -w /condev/$(pwd) \
  -v "$(pwd):/condev/$(pwd)" \
  -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
  -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
  -e USERID=$UID \
  -e GIT_COMMITTER_NAME="author" \
  -e GIT_AUTHOR_NAME="author" \
  -e EMAIL=author@condev.js \
  apaskal/condev:latest'

# To get shell with mounted current directory
condev

# To use container as preconfigured neovim only
condev nvim [filenameInsideCurrentDirectory]
```

You are ready for development with git, nvim, node, yarn, ag, jq, fzf commands available  
Look at https://github.com/app/nvim.lua to see neovim settings, plugins and key bindings

### Screenshot

![image](https://user-images.githubusercontent.com/9341/173394024-a12abbfb-13b0-4af9-b2b8-366acf93cc9b.png)
