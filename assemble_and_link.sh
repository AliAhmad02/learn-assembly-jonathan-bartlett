#!/bin/bash

# Assembles and links all filenames passed as arguments (without extensions)
# The executable ends up with the name of the final argument
for filename in "$@";
do
  as "${filename}.s" -o "${filename}.o"
done
ld "${@/%/.o}" -o "${@: -1}"
