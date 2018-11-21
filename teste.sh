#!/bin/bash


# for i in "${!files[@]}"
# do
#     echo "${i} = ${files[$i]}"
# done
# for i in "${!dirs[@]}"
# do
#     echo "${i} = ${dirs[$i]}"
# done


# option_n(){
#     declare -A move
#     # struct=$1
#     # echo "${struct}"
#     # echo "${!struct[*]}"
#     #^^^^^^^n sei ate q ponto e necessario fazer isto dado que o array que e passado a func esta ja definido
#     #inbestigue-se..........................
#     for i in ${!array[*]}
#     do
#         echo "${i}"
#         if [[ "$i" = *p* ]]; then
#             move["${i}"]=0
#             content=${array["${i}"]}
#             move["${i}"]=${content}
#             echo "${i}"
#         fi
#     done
#     echo "${move[@]}"
# }
declare -A array
array[10]=sop
array[5]=sop/1
array[15]=sop/2

IFS=$'\n' sorted=($(sort <<<"${array[*]}"))
printf "[%s]\n" "${sorted[@]}"
# echo ${array[@]}
# for item in ${!array[@]}
# do
#     echo $item "matches with" ${array[$item]}
# done | sort 

# sort -k1 $array | echo ${array[@]}

# for i in ${!move[*]}
# do
#         echo "${i}"
# done
# if [[ "\t${array[@]}\t" =~ "\t${value}\t" ]]; then
#     echo "yep, it's there"
# fi

#----------------------------------------------------------------------------------------------------------------------------

# array=(one two three four [5]=five)
# declare -A menu
# menu[drink]=coffee
# menu[food]=sandwich
# menu[desert]=pudim

# # for index in ${!array[*]}
# # do
# #     printf "%4d: %s\n" $index ${array[$index]}
# # done

# for item in ${menu[*]}
# do
#     printf "   %s\n" $item
# done

# for animal in "${ARRAY[@]}" ; do
# KEY="${animal%%:*}"
# VALUE="${animal##*:}"
# printf "%s likes to %s.\n" "$KEY" "$VALUE"
# done
#
# printf "%s is an extinct animal which likes to %s\n" "${ARRAY[1]%%:*}" "${ARRAY[1]##*:}"
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

