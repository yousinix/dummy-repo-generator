# Dummy Repo Generator
# Copyright (C) 2019 Youssef Raafat <YoussefRaafatNasry@gmail.com>
# Get latest at : https://github.com/YoussefRaafatNasry/dummy-repo-generator

# Default Values
branches_number=0
merge=false
delete=false
overwrite=false
draw_graph=true
commits_number=5
files_prefix=""

# Overwrite defaults with options' arguments
while getopts "b:mdogn:p:c" opt; do
  case $opt in
    b) branches_number=$OPTARG ;;
    m) merge=true ;;
    d) delete=true ;;
    o) overwrite=true ;;
    g) draw_graph=false ;;
    n) commits_number=$OPTARG ;;
    p) files_prefix="${OPTARG}-" ;;
    c) if [ -d '.git' ]; then
        echo "Clear  :: in progress..."
        git ls-files -z | xargs -0 rm -f
        rm -rf .git
        echo "Clear  :: done"
       else
        echo "Clear  :: failed (not a git repo)"
       fi
       exit 0
       ;;
    *) echo "usage: ./drg.sh [ -b <branches-number> ] [ -m (merge) ]
                [ -d (delete branches after merge) ]
                [ -n <commits-number> ] [ -p <files-prefix> ]
                [ -c (clear repository completely) ]
                [ -g (omit drawing git graph) ]
                [ -o (overwrite existing files instead of appending) ]"
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

  if [ ${branches_number} -ne 0 -a ${bi} -le ${branches_number} ]; then
    echo "Branch :: ${bi} out of ${branches_number}"
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
  while [ ${ci} -le ${commits_number} ]; do
    echo "Commit :: ${ci} out of ${commits_number} on [${current_branch}]"
    file_name="${files_prefix}${ci}"
    if [ -f ${file_name} ]; then
      commit_number=$(wc -l < ${file_name})
      ((commit_number++))
    else
      commit_number=1
    fi
    output="[${current_branch}](${commit_number}) $(date +"%D %T")\r\n"
    if ${overwrite}; then
      echo -ne "$output" > "${file_name}"
    else 
      echo -ne "$output" >> "${file_name}" # append 
    fi
    git add "${file_name}"
    git commit -q -m "$(wget -qO - www.whatthecommit.com/index.txt)"
    ((ci++))
  done

  if [ ${branches_number} -ne 0 ]; then
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

  [ ${bi} -le ${branches_number} ]

do : ; done;

# [Post Generation]
if [ ${branches_number} -ne 0 ]; then
  echo "Switch :: [${src_branch}]"
  git checkout -q ${src_branch}
fi

if ${draw_graph}; then
  git log --oneline --graph --all --decorate 
fi