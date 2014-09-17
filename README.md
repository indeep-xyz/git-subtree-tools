git-subtree-tools
====

shell scripts for git subtree.

## install

```
./install.sh
```

install to _/usr/local/bin/setup-gitstt_ .

## setup

in the beginning, setup for subtree operation in the each git repository for use to `git-subtree-tools`. 

change working directory to root of the git repository that you want setup tools. installed script run as in the following.

```
cd GIT_PROJECT_ROOT
setup-gitstt
```

the generated scripts have some specific parameters. relative path for root of git repository and other.

### Options

#### -d

relative path for the directory. deploy tools and subtree repository to that.

default value is _subtree_ .

#### -f

force setup. overwrite when already exists same name file.

#### -r

in those tools, the subtrees are managed as the remote repository. passed string is used as the prefix for it.

default value is _subtree\__ .

#### -t

the tool name for run to setup. available strings are all, add, pull, push.

default value is all.

## add.sh

add subtree to local repository.

```
./subtree/add.sh [Options] [NAME] [REMOTE_PATH] [BRANCH]
```

NAME is managed by those tools. passed string is used to directory name, or used suffix for name of remote repository.

REMOTE_PATH is remote path for subtree.

BRANCH is branch name for subtree. default value is _master_ .

### Options

#### -s

if set to disable _--squash_ option.

if not set to enable _--squash_ .

## pull.sh

pull from subtree.

```
./subtree/pull.sh [Options] [NAME] [BRANCH]
```

NAME is subtree's name set by `add.sh` . watch the directory name if you have forgotten. if not set, pull from all subtree in the same directory as this script.

BRANCH is branch name for pull. default value is _master_ .

### Options

#### -s

if set to disable _--squash_ option.

if not set to enable _--squash_ .

## push.sh

push to subtree.

```
./subtree/push.sh [Options] [NAME] [BRANCH]
```

NAME is subtree's name set by `add.sh` . watch the directory name if you have forgotten.

BRANCH is subtree's branch name for push.

To prevent wrong operation, all arguments have become essential.

### Options

#### -s

if set to disable _--squash_ option.

if not set to enable _--squash_ .

## AUTHOR

[indeep-xyz](http://indeep.xyz/)
