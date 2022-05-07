#!/bin/bash
# go over all the *.wl files in the directory
for fname_c in "$@"
do
  echo "Removing trailing space in $fname_c"
  sed -i.bak -E 's/[[:space:]]*$$//' $fname_c
  rm $fname_c.bak
done
echo "DONE"
