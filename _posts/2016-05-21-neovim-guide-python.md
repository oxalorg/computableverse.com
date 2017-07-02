---
date: 2016-05-21T00:00:00Z
title: NeoVim quick starter guide with python autocomplete.
slug: neovim-guide-python
tags:
    - guide
    - python
    - neovim
    - autocomplete
---

So there's no simple guide available online which just gets me running really quickly. Most of them are either too detailed, or too obscure. So I decided to post my own.

<!--more-->

Install neovim (guide [here](https://github.com/neovim/neovim/wiki/Installing-Neovim)). On ubuntu it is:

```shell
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

To use the python plugins install neovim python package: 

```shell
sudo pip3 install neovim
#sudo pip2 install neovim
```

Setup the NeoVim config files.

```shell
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
mkdir $XDG_CONFIG_HOME/nvim # You can link .vim here, but I'm starting from scratch.
touch $XDG_CONFIG_HOME/nvim/init.vim
```

Now we install a plugin manager, [dein.vim](https://github.com/Shougo/dein.vim):

```shell
cd /tmp && \
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh &&\
mkdir -p $HOME/.random &&\
sh ./installer.sh $HOME/.random ||\
echo "Failed."
```

The installer will throw a wall of text and ask you to copy-pasta it in your `init.vim` file.

Now we need to let NeoVim know where our python binaries are located.

```vim
let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
```

Uncomment the following lines in your `init.vim` file, which installs plugins on startup:

```vim
if dein#check_install()
  call dein#install()
endif
```

Now to install autocomplete for python. We will use `deoplete.nvim` with `deoplete-jedi` as source. 

```shell
# First install jedi
sudo pip3 install jedi
# Also install yapf for formatting
sudo pip3 install yapf
```

Now add these lines to your `init.vim`:

```vim
call dein#add('Shougo/deoplete.nvim')
call deoplete#enable()

autocmd FileType python nnoremap <leader>y :0,$!yapf<Cr>
autocmd CompleteDone * pclose " To close preview window of deoplete automagically
```

Feel free to checkout my [NeoVim config](https://github.com/MiteshNinja/dotfiles/tree/master/nvim) on github. 
