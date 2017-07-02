---
date: 2016-10-28T00:00:00Z
author: Mitesh Shah
title: Convert any folder into a website using Pandoc and a Makefile
slug: create-website-using-pandoc-make-file
tags:
    - static site generators
    - guide
    - pandoc
    - markdown

---

It was a long day. I was lurking HackerNews and /r/programming.
Things were going slow. I had been taking quite a lot of notes
inside a plain ol' directory. I know, 2016 right?! But every
single note taking application had failed me.

Although I had no use of viewing my *markdown* notes in the
browser, I decided to do it anyways. For the sake of completeness.

I immediately thought of [dystic](https://github.com/oxalorg/dystic),
my personal static site generator, but dissed it as too heavy.
I decided then, that I wanted something I could hack together in
the next 10 minutes.

<!--more-->

I immediately thought of [pandoc](https://pandoc.org).

```
pandoc --toc --from markdown --to html my-note.md -o my-note.html
```

Done. Easy, wasn't it?

Now let's do this for the entire directory, *recursively*. We could
write a simple shell script, but that would run everytime on everyfile.
We don't want that. We want to regenerate the *html* only if the
*markdown* counterpart has been updated since the previous build.

What ~~better~~ faster way than to use GNU Make for `mtime` based
builds.

```
cd /notes
nvim Makefile
```

**/notes/Makefile**:

```make
# Find all markdown files
MARKDOWN=$(shell find . -iname "*.md")
# Form all 'html' counterparts
HTML=$(MARKDOWN:.md=.html)

.PHONY = all tar clean
all: $(HTML)

%.html: %.md
    pandoc --from markdown --to html $< -o $@

tar: $(MARKDOWN)
    tar --exclude=notes.tar.gz --exclude=.git/ -czvf notes.tar.gz ./

clean:
    rm $(HTML)
```

We're almost done. Now just run `make all` in `/notes` and all your
*markdown* files will be built into *html* files. 

Run `make clean` to remove all the html files and run `make tar` to 
backup all your notes.

Simply open your browser and type "/notes" (or your complete
path) into the address bar and voila! It's not pretty but it
works. (PS: use `file:///path/to/folder` if not using chrome)

---

To make your files more pretty use my minimal css theme 
[sakura](https://github.com/oxalorg/sakura) and then change the pandoc
command as follows:

```
cd /notes
wget "https://raw.githubusercontent.com/oxalorg/sakura/master/sakura.css"
pandoc --css /notes/sakura.css --from markdown --to html $< -o $@
```

Now you can remote sync the entire website easily using rsync:

```
rsync --exclude '*.md' source/ destination/
```

That's the basics. This can easily be used to create your own
blog, websites, small projects, pretty much anything. The
best part being that it needs no 'rules' from your end,
you're free to structure your content anyway you like; something
which is missing from almost every static site generator out
there. This is one of my quibbles which I'm trying to fix with
[dystic](https://github.com/oxalorg/dystic).

I added a couple more feature including making automatic
indexes, sorting using title/date, metadata parsing etc. But I
quickly realised that it's a lot of pain to be doing it using
*only* GNU Make. So I've decided to start working on `dystic`
again. Maybe even re-write it in `nim` or `golang`.

Let me know your comments below.
