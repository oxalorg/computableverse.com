---
title: Installing Zim-Wiki on MacOSX (and creating zim.app)
slug: install-zim-wiki-macos-osx
date: 2017-10-16
tags:
- software
---

This is a simple guide to installing zim-wiki on MacOS [OSX].

<!-- date: 2016-10-16 -->

Installation
------------

I'm assuming you already have homebrew installed.

1. First you need to install pygtk

   ```
   brew install pygtk
   ```

	Make sure to note down where the `python` binary gets installed. It will most likely be in `/usr/local/Cellar/python/2.7.12_2/bin/python`

2. Now install GtkOsxApplications (known as gtk-mac-integration for previous macos versions)
	```
	brew install gtk-mac-integration
	```

3. Download the zim tarball from
[http://zim-wiki.org/downloads/](http://zim-wiki.org/downloads/)
4. Double click the downloaded file to get a folder with the same name in the same directory.
5. `cd` into the folder (looking something like "zim-0.65")
6. Now run the `zim.py` file with above python binary as follows:

   ```
   usr/local/Cellar/python/2.7.12_2/bin/python zim.py
   ```


Voila! You're done.

Going Further: Creating Zim.app
-------------------------------

It's a pain to use the command line to always launch zim, so
lets instead create an osx application wrapper for it.

First we need to download a utility called Platypus

```
brew cask install platypus
```

Now open it up. And click on "New Script" (Command-N).

Replace the contents of the popup box with the following text:

```
#!/usr/local/bin/zsh

/usr/local/Cellar/python/2.7.12_2/bin/python ../Resources/zim-0.65/zim.py
```

![](/assets/images/zim-osx/pasted_image.png)

Then hit "Save". Change the other options and include the zim folder we untarred previously as a bundle.

The options should look something like this:

![](/assets/images/zim-osx/pasted_image002.png)

That's about it. You can now "Create App", and BOOM! Everything is done.
