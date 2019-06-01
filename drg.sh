# Dummy Repo Generator
# Copyright (C) 2019 Youssef Raafat <YoussefRaafatNasry@gmail.com>
# Get latest at : https://github.com/YoussefRaafatNasry/dummy-repo-generator

# Default Values
branches_count=0
merge=false
delete=false
commits_count=5
files_prefix=""

# Overwrite defaults with options' arguments
while getopts "b:mdc:p:" opt; do
  case $opt in
    b) branches_count=$OPTARG ;;
    m) merge=true ;;
    d) delete=true ;;
    c) commits_count=$OPTARG ;;
    p) files_prefix="${OPTARG}-" ;;
    *) echo "usage: ./drg.sh [ -b <branches-count> ] [ -m (merge) ]
                [ -d (delete branches after merge) ]
                [ -c <commits-count> ] [ -p <files-prefix> ]"
       exit 0
       ;;
  esac
done

# [Pre Generation]
if [ ! -d '.git' ]; then
  echo "Init   :: initialized git repository"
  git init -q
  echo "Create :: .gitignore file"
  echo -ne "#Ignore script\r\n" >> .gitignore
  echo -ne "${0##*/}\r\n" >> .gitignore
  echo "Create :: .gitattributes file"
  echo -n '* merge=union' >> .gitattributes
  echo "Commit :: Initial on [master] "
  git add .gitignore
  git add .gitattributes
  git commit -q -m 'Initial commit'
fi

# [Generation]
src_branch=$(git rev-parse --abbrev-ref HEAD)
bi=1
while

  if [ ${branches_count} -ne 0 -a ${bi} -le ${branches_count} ]; then
    echo "Branch :: $bi out of $branches_count"
    next_branch="br-${bi}.0"
      if [ `git branch --list ${next_branch}` ]; then
        echo "Switch :: [${next_branch}]"
        git checkout -q ${next_branch}
      else
        echo "Create :: [${next_branch}] from [${src_branch}]"
        git checkout -q -b ${next_branch} ${src_branch}
      fi
    ((bi++))
  fi

  ci=1
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  while [ ${ci} -le ${commits_count} ]; do
    echo "Commit :: ${ci} out of ${commits_count} on [${current_branch}]"
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

  if [ ${branches_count} -ne 0 ]; then
    if ${merge}; then
      echo "Switch :: checkout to [${src_branch}]"
      git checkout -q ${src_branch}
      echo "Merge  :: [${current_branch}] into [${src_branch}]"
      git merge -q --no-ff --no-edit ${current_branch}
    fi

    if ${delete}; then
      echo "Delete :: [${current_branch}]"
      git branch -q -D ${current_branch}
    fi
  fi

  [ ${bi} -le ${branches_count} ]

do : ; done;

# [Post Generation]
if [ ${branches_count} -ne 0 ]; then
  echo "Switch :: [${src_branch}]"
  git checkout -q ${src_branch}
fi
echo "Graph  ::"
echo "---------"
git log --oneline --graph --all --decorate
