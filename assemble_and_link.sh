#!/bin/bash
filename="$1"
echo "${filename}"
as "${filename}.s" -o "${filename}.o"
ld "${filename}.o" -o "${filename}"
