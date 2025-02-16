#!/bin/bash

do_clean() {
  cd "$1"
  for filename in *; do
    length=${#filename}
    if [ $length -le 32 ]; then
      echo "PASS : $filename"
      if [ -d "$filename" ]; then
        do_clean "$filename"
        cd ..
      fi
      continue
    fi

    newfilename="error"

    if [ -d "$filename" ]; then # if it is a file
      trimmed="${filename:0:length-33}"
      newfilename=$trimmed
    else
      trimmed="${filename%.*}"
      extension="${filename##*.}"
      length=${#trimmed}
      all="_all"
      if [[ "$trimmed" == *"_all"* ]]; then
        trimmed="${trimmed:0:length-37}"
        newfilename="$trimmed"_all.$extension
      else
        trimmed="${trimmed:0:length-33}"
        if [ "$extension" == "md" ]; then
          first_line=$(head -n 1 "$filename")
          title="${first_line:2:${#first_line}}"
          title="${title//\//-}"
          trimmed="$title"
        fi
        newfilename=$trimmed.$extension
      fi
    fi

    mv "$filename" "$newfilename"
    echo "RENAMED : $newfilename"

    if [ -d "$newfilename" ]; then
      do_clean "$newfilename"
      cd ..
    fi
  done
}

do_clean $1
