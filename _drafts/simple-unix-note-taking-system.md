---
best: true
draft: true
tags:
    - notes
    - setup
    - simple
title: simple unix note taking system
date: 2017-01-27T22:27:01+05:30
---

Some people love taking notes. They love trying out everything there is
about how to take notes. They write their own note taking software, hate
it, and then write it again. It's a life long journey. Wiki, dream logs,
journals, dear diary, personal twitter feed; we want **everything**. Is
it too much to ask?

<!--more-->

Software, as long as you can do something about it, should posses the
faculty of being intuitive to use. As soon as it crosses that fine
barrier of elementary goodness, it starts to get in your way. So
naturally I *try* to make everything I use as simple as possible and
then I never have to think about it again.

That means I simply can not be a fan boy. Nope. Although I love using
the command line for everything, it's simply not the best tool for every
job, and certainly not the easiest.

Regardless, it works plenty fine for taking notes. Because what are
notes anyways?

> Taking notes is really simple, but we insist on making it complicated.
> -*Confucius*

Man, Confucius surely was ahead of his time.

Notes are just text files. Daily journaling? Text again. Todo lists?
Text. Wiki? Text. So let's just keep it that way and write everything in
text files.

## ox text file saving system

Let's dive deep into how to write, save and edit text files.

### Decide a place to store your text files.

Best place would be dropbox since it takes care of syncing and backups
and you never have to think about it ever again.

```bash
mkdir ~/Dropbox/cabinet/notes
# I like to collect certain things inside a "cabinet"
# The cabinets tale will have to wait for now
```

### Categorise your text files into folders.

```bash
JOURNAL=$CABINET/journal
NOTES=$CABINET/notes

...

/cabinet ❯❯❯ t -d -L 1 journal
journal
├── antisocial
├── diary
├── dreams
├── lists
├── logs
├── movies
├── people
├── places
├── poetry
├── quotes
├── recipes
└── restraunts

12 directories
/cabinet ❯❯❯ t -d -L 1 notes
notes
├── art
├── Athena
├── compsci
├── games
├── gre
├── Hermes
├── old
├── resources
├── rough
├── save
├── snips
└── torrents

12 directories
```

### Allow easy access to text files in those folders

It's time to make writing, saving, and editing process as streamlined as
possible. Keep it simple silly, remember?

#### **Daily text files.**

Files which make sense only for a given day are the easiest to handle.
Name them with a date and they're good to go.

```bash
oxdiary () {
    $EDITOR $CABINET/journal/diary/$(date +%F).md
}

oxdream () {
    $EDITOR $CABINET/journal/diary/$(date +%F).md
}
```

The function `oxdiary` simply creates a new entry in my diary folder
with todays date, and if the file exists it opens the existing file and
I can add my thoughts to it.

I can also give them a name with the time and they start recording your
activity/thoughts at any given moment.

```bash
oxantisocial () {
    $EDITOR $CABINET/journal/antisocial/$(date +%FT%H:%M).md
}
```

#### Text files with an intent, and a context: **NOTES**.

Since notes need more *organising* than a daily entry, we need to get a
bit creative.

First, we need easy access to the notes directory and a scratch pad
where we can offload our minds.

```bash
alias nt='cd $NOTES'

# Edit scratch pad note
# npad (note-pad) and epad (edit-pad) both aliases are
# used to edit the scratch pad.
alias epad="$EDITOR $NOTES/scratch-pad.md"
alias npad="$EDITOR $NOTES/scratch-pad.md"

# cpad is used to cat the scratch pad when you quickly feel like 
# seeing the contents but dont want to edit, or perhaps use it
# in a command like `cpad | pbcopy` to copy its contents
alias cpad="cat /NOTES/scratch-pad.md"

# ppad is the path to the file, just incase you need it 
# for scripting eg. `grep TODO ppad`
# or `pbpaste >> ppad`
alias ppad="$NOTES/scratch-pad.md"
```

Now one of the major features of note taking software is their ability
to clip content from the web. I wanted to find the easiest way I could
think of to save website content, or some random reddit comment I
stumble upon, so I went straight back to `Ctrl + C`.

`nsnip`: Note snip instantly copies the content of your clipboard and
saves it to a file.

```bash
# Create snippet
nsnip() {
    # pbpaste and pbcopy should be mapped to xlcip on linux in zshrc
    local content=pbpaste
    local genname=`pbpaste | head -c 25`
    local filename=${@:-$genname}
    local slug=`echo $filename | sed 's|\ |_|g' | sed 's|[_]*$||'`
    $content >> $NOTES/snips/$(date +%F)-${slug}.md
    echo "\n" >> $NOTES/snips/$(date +%F)-${slug}.md
}
```

It's best explained with an example:

```bash
/c/notes ❯❯❯ cat << w00t | pbcopy
pipe > Let's copy some stuff into our clipboard.
pipe > This can simply be done by Ctrl + C, but
pipe > I am using the command line to look more
pipe > l337.
pipe > w00t

# now simply type the command nsip and see what happens
/c/notes ❯❯❯ nsnip
/c/notes ❯❯❯ cd $NOTES/snips
/c/n/snips ❯❯❯ ls -t | head -n 2
2017-01-27-Let's_copy_some_stuff_int.md
```

There you go, a file with todays name and the first 25 chars of your
clipboard has been saved. You can even provide a custom name with an
argument.

Finally comes the actual notes. For note creating, and over all
searching of all notes, journals, logs, dairy entries etc happens with
the help of two programs.

1.  fzf - fuzzy finder
2.  ag - the silver searcher

<!-- -->

```bash
    ## Notes
    nsearch () {
        cd $NOTES
        local query=$@ || ""
        $EDITOR "$(fzf --preview='head -$LINES {}' -1 -q $query)"
    }

    ncreate () {
        local query=$@ || ""
        local p=$(find -L $NOTES -type d ! -path \*.git\* | sed "s|.*notes||" | fzf -1 -q "$@")
        cd $NOTES/$p
        $EDITOR
    }
    oxfind () {
    # searches for a term, shows a list of all files with that term
    # shows a preview of each file
        local tempd=`pwd`
            cd $CABINET/journal
            local query=${@-""}
        $EDITOR "$(ag -G '(md|txt)$' -l $query | fzf --preview='pygmentize {}' --color light --margin 5,20)"
    }

    oxsearch () {
        ag -G '(md|txt)$' "$@" $CABINET/journal
    }

    oxtags () {
    # searches for ALL tags like #yolo #wow #ethan #great #moves #such doge
    # Specific tag search can simply be done by oxsearch()
        ag -G '(md|txt)$' '#[a-zA-Z\-_0-9!]+' $CABINET/journal
    # TODO: take an argument and do a partial search for that
    }

    oxmentions () {
    # searches for mentions like @ox @rogue @noob @2016-02-16
        ag -G '(md|txt)$' '@[a-zA-Z\-_0-9!]+' $CABINET/journal
    }

    oxtodos () {
        ag -G '(md|txt)$' 'TODO' $CABINET/journal
    }
```
