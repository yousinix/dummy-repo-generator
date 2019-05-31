# Dummy Repo Generator

A bash script to generate git repository with dummy commits.

## Usage

```bash
./drg.sh [ -b <branches-count> ] [ -c <commits-count> ] [ -p <files-prefix> ]
```

**Sample run:** _(messages are fetched from [whatthecommit](http://whatthecommit.com) automatically)_

```console
$ ./drg.sh -b 2 -c 3 -p X
* 205e63e (br-2.0) --help3
* 1cae97d I expected something different.
* 3c43fb1 fix tpyo
| * 00665ab (br-1.0) last minute fixes.
| * 8513143 Who Let the Bugs Out??
| * 7ebec1e Shovelling coal into the server...
|/
* 893026e (HEAD -> master) Initial commit

$ git checkout br-1.0 && ls -a
Switched to branch 'br-1.0'
.git/  .gitignore  drg.sh  X-1  X-2  X-3
```

## Default Values

| Variable         | Value                              |
|:-----------------|:-----------------------------------|
| `branches_count` | `0` (commit to `master` directly)  |
| `commits_count`  | `5`                                |
| `files_prefix`   | `""`                               |

## Collision Handling

If the script is used to generate commits in **existing files**, some of the commit data is just **appended** to the file instead of **overwriting** the whole file.

```text
[1]
Date   : Fri, May 31, 2019  1:41:25 AM
Author : User Name <user_email@gmail.com>
Branch : master

[2]
Date   : Fri, May 31, 2019  1:41:30 AM
Author : User Name <user_email@gmail.com>
Branch : master

[3]
Date   : Fri, May 31, 2019  1:41:36 AM
Author : User Name <user_email@gmail.com>
Branch : master
```