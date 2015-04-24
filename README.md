# Open-Box's dotfiles
----

An ongoing project about linux (and maybe osx) dotfiles systems.

### Install

*** ToDo

```bash
$ cd ~
$ sudo apt-get install git
$ git clone https://github.com/Open-Box/dotfiles
$ cd ~/dotfiles/bin
$ sh ./bootstrap.sh
```

The bostrap script takes care of init git, backup files and organize all the dotfiles logic.

### File Organitation 

#### The right directory structure isn't define yet


According to `@holman` project (see reference for details), dotfiles logic is divided around topic. 
The only exception is the `bin` directory containg executable script files.

Inside every directory you can find a special file hierarchy:


- **topic/\*.bash**: Any files ending in `.bash` get loaded into your
  environment.
- **topic/*.path**: Any file named `*.path` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/*.completion: Any file named `*.completion` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `bin/bootstrap`.
  
- **config/gitconfig.example**: template file without credentials info used to 
  generate a copy in your  `$HOME`. 

- **config/**: not used yet in auto mode
- **general/**: not used yet
- **init/**: not used yet

### Installing software

Todo
___

### Unpdate Stuff

ToDo
___

### Uninstall

ToDo
___

### Resource References

This project is based on ideas found (in a random order) at the following links:

* [dotfiles site](http://www.dotfiles.org)
* [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles)
* [Using Git and Github to Manage Your Dotfiles](http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/)
* [Michael J. Smalley's dotfiles](https://github.com/michaeljsmalley/dotfiles)
* [Dotfiles Are Meant to Be Forked](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/)
* [Zach Holman's dotfiles](https://github.com/holman/dotfiles)
* [Ben Alman's dotfiles](https://github.com/cowboy/dotfiles)
* [Johnathan Mark Smith's dotfiles](https://github.com/JohnathanMarkSmith/mintdotfiles)
* [Ryan Bates's dotfiles](https://github.com/ryanb/dotfiles)
* [Github's dotfiles document](https://dotfiles.github.io/)

## Feedback

Suggestions/improvements
[welcome](https://github.com/Open-Box/dotfiles/issues)!

