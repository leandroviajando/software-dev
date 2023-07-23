#!/usr/bin/env bash

shopt -s nullglob

# YYYY-MM-DD
DATE=$(date +%F)

for FILE in *.jpg
do
  mv $FILE ${DATE}-${FILE}
done
