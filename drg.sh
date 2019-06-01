# Dummy Repo Generator
# Copyright (C) 2019 Youssef Raafat <YoussefRaafatNasry@gmail.com>
# Get latest at : https://github.com/YoussefRaafatNasry/dummy-repo-generator

# Default Values
branches_count=0
merge=false
commits_count=5
files_prefix=""

# Overwrite defaults with options' arguments
while getopts "b:mc:p:" opt; do
  case $opt in
    b) branches_count=$OPTARG ;;
    m) merge=true ;;
    c) commits_count=$OPTARG ;;
    p) files_prefix="${OPTARG}-" ;;
    *) echo "Usage: ${0} [ -b <branches-count> ] [ -m (merge) ] [ -c <commits-count> ] [ -p <files-prefix> ]" ;;
  esac
done

# [Pre Generation]
if ${merge} && [ ! -e '.gitattributes' ]; then
  echo -n '* merge=union' >> .gitattributes
fi

if [ ! -d '.git' ]; then
  git init -q
  echo -ne "#Ignore script\r\n" >> .gitignore
  echo -ne "${0##*/}\r\n" >> .gitignore
  git add .gitignore
  git commit -q -m 'Initial commit'
fi

# [Generation]
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
      commit_number=$(wc -l < ${file_name})
      ((commit_number++))
    else
      commit_number=1
    fi
    echo -ne "[${current_branch}](${commit_number}) $(date +"%D %T")\r\n" >> "${file_name}"
    git add "${file_name}"
    git commit -q -m "$(curl -s http://whatthecommit.com/index.txt)"
    ((ci++))
  done

  if ${merge}; then
    echo -ne "Merging [${current_branch}] into [${src_branch}]...\r"
    git checkout -q ${src_branch}
    git merge -q --no-ff --no-edit ${current_branch}
    echo -ne "\033[K"
  fi

  [ ${bi} -le ${branches_count} ]

do : ; done;

# [Post Generation]
git checkout -q ${src_branch}
echo -ne "\033[K" # Erase to end of line
git log --oneline --graph --all --decorate
