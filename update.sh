#!/bin/bash
while IFS=',' read -r name repourl remotebranch forceupdate ; do
  if [ "$name" != "name" ]; then
    echo "$name $repourl $remotebranch"
    set -x
    if git show-ref --quiet refs/heads/"$name"; then
      git checkout "$name"
    else
      git checkout --orphan "$name"
      git rm -rf . > /dev/null 2>&1
    fi

    if [ "$forceupdate" != "yes" ]; then
      git pull "$repourl" "$remotebranch"
    else
      git fetch "$repourl" "$remotebranch"
      git reset --hard FETCH_HEAD
    fi
    git push -f -u origin "$name"
  fi
done < index.csv
