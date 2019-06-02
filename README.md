# Dummy Repo Generator

A bash script to generate git repository with dummy commits.

## Usage

```bash
./drg.sh [ -b <branches-number> ] [ -m (merge) ]
         [ -d (delete branches after merge) ]
         [ -n <commits-number> ] [ -p <files-prefix> ]
         [ -c (clear repository completely) ]
```

**Sample run:** _(messages are fetched from [whatthecommit](http://whatthecommit.com) automatically)_

```console
$ ./drg.sh -b 2 -m -n 3 -p X
Init   :: initialized git repository
Create :: .gitignore file
Create :: .gitattributes file
Commit :: Initial on [master]
Branch :: 1 out of 2
Create :: [br-1.0] from [master]
Commit :: 1 out of 3 on [br-1.0]
Commit :: 2 out of 3 on [br-1.0]
Commit :: 3 out of 3 on [br-1.0]
Switch :: checkout to [master]
Merge  :: [br-1.0] into [master]
Branch :: 2 out of 2
Create :: [br-2.0] from [master]
Commit :: 1 out of 3 on [br-2.0]
Commit :: 2 out of 3 on [br-2.0]
Commit :: 3 out of 3 on [br-2.0]
Switch :: checkout to [master]
Merge  :: [br-2.0] into [master]
Switch :: [master]
Graph  ::
---------
*   3e7d181 (HEAD -> master) Merge branch 'br-2.0'
|\
| * 9f03d5b (br-2.0) fix tpyo
| * 3edb486 Who Let the Bugs Out??
| * b05b011 Continued development...
|/
*   2bd2817 Merge branch 'br-1.0'
|\
| * cfdfe8c (br-1.0) hoo boy
| * b9925ae I know what I am doing. Trust me.
| * 105dd49 just trolling the repo
|/
* 92038af Initial commit

$ ls -a
.git/  .gitattributes  .gitignore  drg.sh  X-1  X-2  X-3
```

## Default Values

| Variable          | Value                              |
|:------------------|:-----------------------------------|
| `branches_number` | `0` (commit to `master` directly)  |
| `merge`           | `false`                            |
| `delete`          | `false`                            |
| `commits_number`  | `5`                                |
| `files_prefix`    | `""`                               |

## Collision Handling

If the script is used to generate commits in **existing files**, some of the commit data is just **appended** to the file instead of **overwriting** the whole file.

```text
[br-1.0](1) 06/01/19 03:47:55
[br-2.0](2) 06/01/19 03:47:58
[br-3.0](3) 06/01/19 03:48:02
```
