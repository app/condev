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

### Optional setting of color theme

You can choose one of six color themes. Dark or Light.  
`dogrun, dracula, gruvbox, onedarkpro, solarized, vscode`  
Just add this with -e parameter to alias command above

```
NVIM_THEME=vscode
NVIM_BGCOLOR=dark
```

`NVIM_THEME` valid values are: dogrun, dracula, gruvbox, onedarkpro, solarized, vscode.  
`NVIM_BGCOLOR` valid values are: dark or light  
Please note `dracula` and `dogrun` is dark mode only themes.  
And `solarized` patched up to dark-dark gray background color.

### That's all

You are ready for development with git, nvim, node, yarn, ag, jq, fzf commands available  
Look at https://github.com/app/nvim.lua to see neovim settings, plugins and key bindings

### Screenshots

Solarized color theme
![Solarized](https://user-images.githubusercontent.com/9341/174473139-b0d633f4-4354-49c2-a5b3-02fdd5170334.png)

Dracula color theme  
![Screenshot from 2022-06-19 11-37-21](https://user-images.githubusercontent.com/9341/174472858-85f8555c-aa98-4370-8d77-ab40d1da7c84.png)

Gruvbox color theme  
![Grovebox](https://user-images.githubusercontent.com/9341/174473015-ab1908c6-11ee-4a7b-a0fe-fe2ad4aed372.png)

... and other themes are also available: `dogrun`, `onedarkpro`, `vscode`
