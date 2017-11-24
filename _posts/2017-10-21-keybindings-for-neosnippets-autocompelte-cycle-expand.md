---
date: 2017-10-21
title: Intuitive keybindings for NeoSnippets and Deoplete autocomplete tab cycling
slug: my-terminal-setup
tags:
- workflow
- setup
- terminal
- zsh
- dotfiles
---

So I’ve been using `deoplete` along with `NeoSnippets` for
mostly local auto completion and the like. It’s really fast,
and works really well.

The only issue was the default `C-n`, `C-p`, `C-k`, defaults
to move in the completion menu and complete it.

<!-- more -->

So here’s a snippet from my [init.vim][1] which makes these
sane and intuitive like IDE’s and other modern text editors
like Atom, Sublime, VSCode, etc.

```viml
“ Map expression when a tab is hit:
“           checks if the completion popup is visible
“           if yes 
“               then it cycles to next item
“           else 
“               if expandable_or_jumpable
“                   then expands_or_jumps
“                   else returns a normal TAB
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

“ Expands or completes the selected snippet/item in the popup menu
imap <expr><silent><CR> pumvisible() ? deoplete#mappings#close_popup() .
      \ "\<Plug>(neosnippet_jump_or_expand)" : "\<CR>"
smap <silent><CR> <Plug>(neosnippet_jump_or_expand)
```

[1] : https://github.com/oxalorg/dotfiles/
