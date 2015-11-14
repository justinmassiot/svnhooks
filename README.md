# svnhooks
Framework and example hook scripts for SVN (Subversion).

This project is licensed under the version 2.0 of the Apache License, the same that is used from the [Subversion project](https://subversion.apache.org/) itself.

## Hook scripts for SVN
### Ressources about hooks
This project is about SVN hook scripts, or "hooks". If you are not familiar with them yet, please read the [official documentation for hook scripts](http://svnbook.red-bean.com/nightly/en/svn.reposadmin.create.html#svn.reposadmin.hooks).

Useful ressources to implement hooks are available as part of the SVN project files:
 1. http://svn.apache.org/repos/asf/subversion/trunk/tools/hook-scripts/
 2. http://svn.apache.org/repos/asf/subversion/trunk/contrib/hook-scripts/

There are also many more user scripts everywhere on the web.

### Hooks provided by the project
This project offers _some_ example hooks that could be useful in _some_ particular cases of application (actually, mine). Because they exist, I share them as a part of the project but **be aware that they may not fit your needs**. You are in charge to adapt those scripts to your own infrastructure, tools, policies, etc.

Of course you can use the existing scripts as examples to write your own scripts.

## Launcher for SVN hooks
This project provides the 9 standard SVN hooks as generic launchers for your own scripts. Each one of the nine hooks executes the `execute_all_same_hooks.sh` script which then runs the approriate job(s) of your choice.

### How does it work
This framework will loop through all the files inside the original hook folder and execute all scripts that match the filename pattern. Thus, to create a server-hook functionality you simply have to create a file called `your-hook-type*1234*`. If the `post-commit` hook is triggered, `execute_all_same_hooks.sh` is going to run all scripts with a file name like **`post-commit(any characters)(any number)(any characters)`**. It is going to accept `post-commit.01`, `post-commit51`, `post-commit.02.py` but not `post-commit.foo`.

Example list of valid names:
* post-commit1
* post-commit.1_hello
* post-commit-01.myhook-verycool.sh
* post-commit_123_myhook-verycool.sh

Example list of **invalid** names:
* post-commit.hello
* post-commit.hello.py

You can even create a symbolic link to an existing script or binary:
```sh
ln -s /usr/bin/mysupertool post-commit.81.linktomysupertool
```

### Execution order
The framework executes the files in "natural" order, which means that `post-commit.2` would be executed after `post-commit.1`.

Just like a Linux system manages start-up/shutdown scripts, we strongly advise you to follow the _proposed naming scheme_:
* hooktype.**1x** => pre server-side operations (available space, mirroring tasks, etc.)
* hooktype.**2x** => authentication
* hooktype.**3x** => rights management
* hooktype.**4x** => _not in use (reserved for future needs)_
* hooktype.**5x** => transaction verifications (at least for properties: log message, tracker ID, author, etc.)
* hooktype.**6x** => content check (file types, syntax, unauthorized files, etc.)
* hooktype.**7x** => _not in use (reserved for future needs)_
* hooktype.**8x** => after-operation processing (e-mails, auto-commit, etc.)
* hooktype.**9x** => post server-side operation

Hint 1: Be consistent in the choice of your filenames because it will then determine the order of execution! In our example scripts we always use a `hook-type.12.*` name format.

Hint 2: _Not all suffixes are valid for all hook types._ Please only use suffixes that are appropriate in the context of the hook.

Example of "good" script names:
* pre-commit.31
* pre-commit.51.sh
* post-commit.81.py

## Sidenotes
Always make your scripts executables by doing a `chmod` on them (`chmod +x` is the most simple solution).

The pre-lock hook must generate the lock token UUID itself. If it does not, the lock operation is impossible, that's why we prefer to disable this hook by default. More info on http://inst.eecs.berkeley.edu/~cs61b/fa12/docs/svn-book-html-chunk/svn.ref.reposhooks.pre-lock.html .
