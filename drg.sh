# Dummy Repo Generator
# Copyright (C) 2019 Youssef Raafat <YoussefRaafatNasry@gmail.com>
# Get latest at : https://github.com/YoussefRaafatNasry/dummy-repo-generator

# Default Values
commits_count=5
files_prefix=""

# Overwrite defaults with options' arguments
while getopts "c:p:" opt; do
  case $opt in
    c) commits_count=$OPTARG ;;
    p) files_prefix="${OPTARG}-" ;;
    *) echo "Usage: ${0} [ -c <commits-count> ] [ -p <files-prefix> ]" ;;
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
current_branch=$(git rev-parse --abbrev-ref HEAD)
i=1
while [ $i -le $commits_count ]; do
  file_name="${files_prefix}${i}"
  if [ -f $file_name ]; then
    commit_number=$(($(wc -l < $file_name) / 5 + 1))
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
  echo -ne "[${current_branch}] commit $i out of $commits_count\r"
  ((i++))
done

# [Post Generation]
echo -ne "\033[K" # Erase to end of line
git log --oneline --graph --all --decorate
