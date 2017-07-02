---
date: 2016-01-09T00:00:00Z
best: true
title: 'Atom: Love at first sight'
slug: Atom-Love-at-first-sight

tags:
    - workflow
    - thoughts
    - text editors
    - atom
    - vim

---

I've had a love/hate relation with VIM and Sublime over the past few months. I love the concept of flow-based editing i.e vim-fu, but I also love the ease and beauty of sublime text.

I was tired of switching between the two and figuring out which is better. So I did something *unexpected*. I installed [Atom](https://atom.io).

<!--more-->

I had tried Atom back in the beta days, and frankly it did not leave a remarkable experience on me. It was slow and clunky, which is why I decided to stick to the *top guns* of the time.

I got Atom v1.3.0 installed on by ubuntu-box and fired it up.

~~~sh
sudo add-apt-repository ppa:webupd8team/atom
sudo apt-get update
sudo apt-get install atom
~~~

### First looks

Damn was it beautiful. I knew it that very second, on the 'Welcome' screen, that **this** is what I'm going to be using from now.

A lot of people argue that aesthetics aren't relevant for a text-editor, after all we do use mono-spaced fonts, and I've seen countless posts and discussions, usually started by vim/emac fans, revolving around this very fact. But I beg to differ. I stare *directly* into an editor for the better part of my day, it makes a huge difference if it is aesthetically pleasing or not.

That doesn't mean aesthetics > functionality, and that is one of the reasons I don't hate command line embedded editors.

### Beautifying it further.

With more than 10 built in themes and syntax options, you really don't need to do any more 'manual' customization.

But that's not going to happen. So here we go.

A built in package manager is a warm welcome with intuitive and easy ways to customize and install packages, as easy as `apm install atom-beautify`.

A quick look over the top packages on their [package control site](https://atom.io/packages/list), gave plenty of amazing packages which could be installed in less than a minute.

I decided to install these:

~~~sh
$ sort apm-packages

atom-beautify
atom-terminal
autoclose-html
autocomplete-paths
autocomplete-python
file-icons
fonts
git-log
git-plus
highlight-selected
linter
linter-flake8
merge-conflicts
sublime-style-column-selection
vim-mode
zen

$ cat apm-packages | xargs apm install
~~~

I'd advise you against installing all those *before* reading what they do. You can however open their respective package pages using this simple command:

~~~sh
awk '{print "https://atom.io/packages/"$1}' apm-packages | xargs google-chrome
~~~

Changed my font to **Inconsolata-G** (my current code favourite) using the `fonts` package and I was ready to go.

### < > with <3 by GitHub

One would think that a text editor made by GitHub would have excellent Git integration. I wish that were true.

Yes, they have amazing gutter git-diff colors and several other options like viewing a list of new/modified files since the last commit. Also shows the number of insertion/deletions, branch etc in the status bar.

The `git-plus` package adds a lot of functionality like *add, push, pull, commit, unstage etc..* which should have been provided in the base installation by atom. The package itself lacks polish and is rather unintuitive to use.

I constantly found myself switching back to the terminal to interface with Git (`atom-terminal` makes this extremely easy).

Also, GitHub has been strongly in support of Markdown yet I find almost non-existant markdown based features available, except for backtick on-the-fly syntax highlighting and live preview.

It has also managed to freeze my complete OS (Ubuntu 14.04) twice when using the `zen` package written by *Chris Wanstrath*, co-founder of GitHub, for distraction free writing (which should have been a feature of the stock editor). I haven't been able to pinpoint or reproduce the issue, but I hope it does not persist.

Apart from this, and a couple of hiccups like no inbuilt block selections, I'm really liking **Atom** so far.
