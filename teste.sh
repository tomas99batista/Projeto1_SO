#!/bin/bash
#----------------------------------------------------------------------------------------------------------------------------
# for f in *; do
#     if [[ -d $f ]]; then
#         $f is a directory
#     fi
# done
# function listagem(){
# for f in $dir/* ; do
#     dir=$f
#         if [ -d ${dir} ]; then
#             # Will not run if no directories are available
#             echo $dir
#             listagem
#         fi
# done
# }
#----------------------------------------------------------------------------------------------------------------------------
# shopt -s globstar
# for i in ./**/*
# do
#     if [ -f "$i" ];
#     then
#         printf "Path: %s\n" "${i%/*}" # shortest suffix removal
#         printf "Filename: %s\n" "${i##*/}" # longest prefix removal
#         printf "Extension: %s\n"  "${i##*.}"
#         printf "Filesize: %s\n" "$(du -b "$i" | awk '{print $1}')"
#         # some other command can go here
#         printf "\n\n"
#     fi
# done
#----------------------------------------------------------------------------------------------------------------------------

