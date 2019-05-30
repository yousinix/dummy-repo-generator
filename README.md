# Dummy Repo Generator

A bash script to generate git repository with dummy commits.

##### Sample generated Repo

```tree
repo/
├── .git/
├── .gitignore
├── 1
├── 2
├── 3
├── 4
├── 5
└── drg.sh
```

##### Repo history _(messages are fetched from [whatthecommit](http://whatthecommit.com))_

```bash
* b3c4486 (HEAD -> master) Reinventing the wheel. Again.
* 75c56da Shovelling coal into the server...
* a52bc63 Oh no
* 1e0753c another big bag of changes
* e780d62 somebody keeps erasing my changes.
* 69beab8 oops
* c6da679 Removed code.
* 9069455 I AM PUSHING.
* f00f58a Initial commit
```

## Usage

```bash
./drg.sh [ -c <commits-count> ] [ -p <files-prefix> ]
```

## Default Values

| Variable        | Value |
|:----------------|:-----:|
| `commits_count` | `5`   |
| `files_prefix`  | `""`  |

## Collision Handling

If the script is used to generate commits in **existing files**, some of the commit data is just **appended** to the file instead of **overwriting** the whole file.

```text
[1]
Date   : Fri, May 31, 2019  1:41:25 AM
Author : Youssef Raafat <YoussefRaafatNasry@gmail.com>
Branch : master

[2]
Date   : Fri, May 31, 2019  1:41:30 AM
Author : Youssef Raafat <YoussefRaafatNasry@gmail.com>
Branch : master

[3]
Date   : Fri, May 31, 2019  1:41:36 AM
Author : Youssef Raafat <YoussefRaafatNasry@gmail.com>
Branch : master
```