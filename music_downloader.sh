#!/bin/bash

BASE_DIR=""
COUNT=$(cat "$BASE_DIR/todo.txt" | wc -l)

for i in $(seq $COUNT)
do
  line=$(head -n 1 $BASE_DIR/todo.txt)
  url=$(echo $line | cut -d' ' -f1)
  name=$(echo $line | cut -d' ' -f2)

  echo "[Downloading] $name | $url"
  mkdir $BASE_DIR/tmp
  yt-dlp -x -f worst --audio-format mp3  $url -P $BASE_DIR/tmp

  if [[ $? == 0 ]]
  then
    echo "Download Complete for $name"
    mv "$BASE_DIR/tmp/$(ls $BASE_DIR/tmp)" "$BASE_DIR/content/$name.mp3"
    echo $line >> "$BASE_DIR/done.txt"
  else
    echo "Download Failed for $name"
    echo $line >> "$BASE_DIR/failed.txt"
  fi
  x=$(cat $BASE_DIR/todo.txt | wc -l)
  tail -n $(( $x - 1 )) "$BASE_DIR/todo.txt" > "$BASE_DIR/todo.txt.swp"
  cp "$BASE_DIR/todo.txt.swp" "$BASE_DIR/todo.txt"
  rm -r $BASE_DIR/tmp
done
