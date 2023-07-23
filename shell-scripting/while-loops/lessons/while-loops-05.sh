#!/usr/bin/env bash

grep xfs /etc/fstab | while read LINE
do
  echo "xfs: ${LINE}"
done
