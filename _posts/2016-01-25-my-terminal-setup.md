---
date: 2016-01-25T00:00:00Z
title: My terminal setup 2016
slug: my-terminal-setup
tags:
    - workflow
    - setup
    - terminal
    - zsh
    - dotfiles
---

It's a pain to remember and reconfigure my keyboard junkie setup every time I change systems, or re-install the OS.

So I'm writing my process down to make it easier to bootstrap and remember.

You can find my `~/dotfiles` repository [here](https://github.com/miteshninja/dotfiles "dotfiles.git").

<!--more-->

### Screenshot:

[![screenshot-terminal](/assets/images/terminal-01.png)](/assets/images/terminal-01.png)


### Shell

My shell of choice is 'zsh'.

~~~sh
sudo apt-get install zsh
chsh -s $(which zsh)
~~~

I avoid using frameworks for zsh since most of them are bloated, i.e. contain a lot of excessive functions and options.

I have a custom [zsh cofiguration](https://github.com/MiteshNinja/dotfiles/tree/master/zsh "dotfiles/zsh") picked and parceled from several sources, and I use [zgen](https://github.com/tarjoilija/zgen) plugin manager for minimal overhead.

zgen being extremely easy to install and setup, the whole process of configuring my *zsh* can be automated using [this](https://github.com/MiteshNinja/dotfiles/blob/master/zsh/setup.sh) script:

~~~sh
if [ -e ~/.zshrc -o -L ~/.zshrc ]; then
        echo "Backing up existing .zshrc."
        mv ~/.zshrc ~/.zshrc.$(date +%F-%R).bak
fi

if [ -d ~/.config/zsh -o -L ~/.config/zsh ]; then
        echo "Backing up zsh folder"
        mv ~/.config/zsh ~/.config/zsh.$(date +%F-%R).bak
fi

echo "Soft linking zsh to ~/.config/zsh"
ln --symbolic -v ${DOTFILESDIR}/zsh ${HOME}/.config/

echo "Soft linking .zshrc to ~/.zshrc"
ln --symbolic -v ${HOME}/.config/zsh/.zshrc ${HOME}/

if ! [ -e ~/zgen/zgen.zsh -o -L ~/zgen/zgen.zsh ]; then
	cd ~
	git clone https://github.com/tarjoilija/zgen
fi

echo "Now run 'source ~/.zshrc' to activate your settings."
~~~

### Terminal

I use 2 different terminal emulators to suit my needs.

['Sakura'](http://www.pleyades.net/david/projects/sakura) is a lightweight, yet configurable terminal emulator with Gtk dependencies.
I downloaded and set it as my default terminal using:

~~~sh
sudo apt-get install sakura
sudo update-alternatives --config x-terminal-emulator
gsettings set org.gnome.desktop.default-applications.terminal exec 'sakura'
# if this doesn't work, run this too
# gsettings set org.gnome.desktop.default-applications.terminal exec-arg ""
~~~

I also installed and set up Guake to have a quick drop down terminal to handle quick one time commands and sometimes the music player.

#### Tmux

In the above 2 terminal emulators, I almost always have a [tmux](https://tmux.github.io/) (terminal-multiplexer) session open. Having the freedom to create and arrange multiple panes and windows is extremely useful.

I have a simple [configuration](https://github.com/MiteshNinja/dotfiles/tree/master/tmux "dotfiles/tmux") present over in my dotfiles repo and actvating it is as simple as linking `.tmux.conf` to the `~/` $HOME directory.

### GymnasticZ

I'm currently using 2 tools for some handy shell gymnastics.

**['z'](https://github.com/rupa/z)**: This handy tool keeps tracks of your 'frecency (frequently+recently) used directories and helps you jump around.

There are many tools available which provide such functionality, like 'autojmp', 'v', 'fasd' etc. But I found 'z' to be straight to the point and easy to install. I am currently reading the autojmp source and might try it out later (python ftw!).

**['fzf'](https://github.com/junegunn/fzf/)**: This one is pretty handy. It's a command line fuzzyfinder tool. It's fast, easy to pipe into, and super easy to setup. It supports fuzzy completion for bash/zsh shell and thus can work with any command  which is pretty handy imo. The reverse fuzzy search and integration with vim is a huge plus.


Apart from these, I keep expanding my toolset as and when necessary. I haven't talked about `vim` or `zsh` configuration in details because that's another story for another time!
