# Dummy Repo Generator
# Copyright (C) 2019 Youssef Raafat <YoussefRaafatNasry@gmail.com>
# Get latest at : https://github.com/YoussefRaafatNasry/dummy-repo-generator

# Default Values
branches_count=0
commits_count=5
files_prefix=""

# Overwrite defaults with options' arguments
while getopts "b:c:p:" opt; do
  case $opt in
    b) branches_count=$OPTARG ;;
    c) commits_count=$OPTARG ;;
    p) files_prefix="${OPTARG}-" ;;
    *) echo "Usage: ${0} [ -b <branches-count> ] [ -c <commits-count> ] [ -p <files-prefix> ]" ;;
  esac
done

# [Pre Generation]
if [ ! -d '.git' ]; then
  git init -q
  echo -ne "#Ignore script\r\n" >> .gitignore
  echo -ne "${0##*/}\r\n" >> .gitignore
  git add .gitignore
  git commit -q -m 'Initial commit'
fi

# [Generation]
author="$(git config user.name) <$(git config user.email)>" 
src_branch=$(git rev-parse --abbrev-ref HEAD)

bi=1
while

  if [ ${branches_count} -ne 0 -a ${bi} -le ${branches_count} ]; then
    next_branch="br-${bi}.0"
      if [ `git branch --list ${next_branch}` ]; then
        git checkout -q ${next_branch}
      else
        git checkout -q -b ${next_branch} ${src_branch}
      fi
    ((bi++))
  fi

  ci=1
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  while [ ${ci} -le ${commits_count} ]; do
    echo -ne "[${current_branch}] commit $ci out of $commits_count\r"
    file_name="${files_prefix}${ci}"
    if [ -f ${file_name} ]; then
      commit_number=$(($(wc -l < ${file_name}) / 5 + 1))
    else
      commit_number=1
    fi
    {
      echo -ne "[${commit_number}]\r\n"
      echo -ne "Date   : $(date)\r\n"
      echo -ne "Author : ${author}\r\n"
      echo -ne "Branch : ${current_branch}\r\n"
      echo -ne "\r\n"
    } >> "${file_name}"
    git add "${file_name}"
    git commit -q -m "$(curl -s http://whatthecommit.com/index.txt)"
    ((ci++))
  done

  [ ${bi} -le ${branches_count} ]

do : ; done;

# [Post Generation]
git checkout -q ${src_branch}
echo -ne "\033[K" # Erase to end of line
git log --oneline --graph --all --decorate
