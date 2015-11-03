# svnhooks
Framework and example hook scripts for SVN (Subversion).

## Launcher for SVN hooks
This project provides the 9 standard SVN hooks as generic launchers for your own scripts. Each one of the nine hooks executes the `execute_all_same_hooks.sh` script which then runs the approriate job(s) of your choice.

Just like a Linux system does at start-up, this framework will run all hooks corresponding to the current operation. If the `post-commit` hook is triggered, `execute_all_same_hooks.sh` is going to run all scripts with a file name like `post-commit.*`. Thus, to create a server-hook functionality you simply have to create a file called `your-hook-type.*`.

Example list of valid names:
* post-commit.1
* post-commit.hello
* post-commit.hello.py
* post-commit.1_hello
* post-commit.1.myhook-verycool.sh
* post-commit.1_myhook-verycool.sh

You can even create a symbolic link to an existing script or binary:
```sh
ln -s /usr/bin/mysupertool post-commit.linktomysupertool
```

## Execution order
The framework executes the files in "natural" order, which means that `post-commit.2` would be executed after `post-commit.1`.

As for the Linux start-up/shutdown scripts, we strongly advise you to follow the proposed naming scheme:
* hooktype.**1x** => pre server-side operations (available space, mirroring tasks, etc.)
* hooktype.**2x** => authentication
* hooktype.**3x** => rights management
* hooktype.**4x** => _not in use (reserved for future needs)_
* hooktype.**5x** => transaction verifications (at least for properties: log message, tracker ID, author, etc.)
* hooktype.**6x** => content check (file types, syntax, unauthorized files, etc.)
* hooktype.**7x** => _not in use (reserved for future needs)_
* hooktype.**8x** => after-operation processing (e-mails, auto-commit, etc.)
* hooktype.**9x** => post server-side operation

Not all suffixes are valid for all hook types. Please only use suffixes that are appropriate in the context of the hook.

Example script names:
* pre-commit.31
* pre-commit.51.sh
* post-commit.81.py

## Sidenotes
Always make your scripts executables by doing a `chmod` on them (`chmod +x` is the most simple solution).

The pre-lock hook must generate the lock token UUID itself. If it does not, the lock operation is impossible, that's why we prefer to disable this hook by default. More info on http://inst.eecs.berkeley.edu/~cs61b/fa12/docs/svn-book-html-chunk/svn.ref.reposhooks.pre-lock.html .
