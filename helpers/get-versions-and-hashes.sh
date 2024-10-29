#!/usr/bin/env bash

[[ "${OSTYPE}" =~ ^linux ]] || { echo "We need linux for gnu-stat." ; exit 1 ; }

# https://exiftool.org/history.html
for X in 13.{00..02} ; do
  grep "\s\+$X:" "${0%/*}/../vars/main.yml" && continue
  file="Image-ExifTool-$X.tar.gz"
  wget -q "https://exiftool.org/$file" || continue
  echo "\"$X\": $(sha1sum "$file" | awk '{print $1}') # $(stat -c "%y" "$file" | awk '{print $1}')"
  echo "Sleeping for 65 seconds to avoid being banned" && sleep 65
done
