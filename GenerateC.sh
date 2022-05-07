#!/bin/bash
# go over all the *.wl files in the directory
for fname_wl in "$@"
do
  fname=${fname_wl%".wl"}
  fname_c=$fname.c
  echo "Generating $fname_c ..."
  wolframscript -f $fname_wl
  echo "Removing trailing space in $fname_c"
  sed -i.bak -E 's/[[:space:]]*$$//' $fname_c
  rm $fname_c.bak
done
echo "All Done"
