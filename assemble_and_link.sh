#!/bin/bash
filename="$1"
as "${filename}.s" -o "${filename}.o"
ld "${filename}.o" -o "${filename}"
