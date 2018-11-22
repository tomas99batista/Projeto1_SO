#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#//TODO: totalspace not working
#//TODO: Tratar -d input M D H:M
#//TODO: Tratar da -l
#//TODO: Ver se no -L imprimir com extensao e tudo
#//TODO: Ver -r && -a

#//TODO: Caminhos relativos e absolutos ?
#//TODO: Espacos nos caminhos
#//TODO: NA nos files
#//TODO: ./nspace
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#MAIN
n_flag=0
l_flag=0
d_flag=0
L_flag=0
r_flag=0
a_flag=0
while getopts ':n:f:l:d:L:ra' OPTION; do
    case "$OPTION" in
        n)
            n_flag=1
            nvalue="$OPTARG"
            # echo "ligou n"
        ;;
        l)
            l_flag=1
            lvalue="$OPTARG"
            # echo "ligou l"
        ;;
        d)
            d_flag=1
            dvalue="$OPTARG"
            # echo "ligou d"
        ;;
        L)
            L_flag=1
            Lvalue="$OPTARG"
            # echo "ligou L"
        ;;
        r)
            r_flag=1
            # echo "ligou r"
        ;;
        a)
            a_flag=1
            # echo "ligou a"
        ;;
        \?)
            echo "$(basename $0) OPTIONS: [-n arg] [-l arg] [-d arg] [-L arg] [-r] [-a]" >&2
            exit 1
        ;;
    esac
done
shift "$(($OPTIND - 1))"

#if -l and -L are passed to the function, display a message and exits the script
if (( $l_flag == 1 && $L_flag == 1 )); then
    printf "Not possible to combine -l and -L, try again please.\n"
    exit 1  #1=code error
fi

# #Recursive function to list directories and files
declare -A dirs
declare -A files
walk() {
    for entry in "$1"/*; do
        totalspace=0 #<<<<<<<<<<<<<<<<<<<<<<<<<<
        if [[ -f "${entry}" ]]; then
            #arg_date=$(date -d ${dvalue} +"%Y%m%d")
            #date=stat $i | head -5 | tail -1 | cut -d " " -f2
            #date=$(date -d ${date} +"%Y%m%d")
            size="$(stat $entry | head -2 | tail -1 | awk '{print $2}')"
            if [ "$l_flag" = 0 ]; then  #l = false
                if (( $d_flag == 1 && $n_flag == 1 )); then #d e n true
                    if [[ "$entry" = *${nvalue}* ]]; then
                        #IF DATAAAA <<<<<<<<<<<<<<<<<
                        #if [ $arg_date -ge $date ]; then
                        files["${entry}"]=$size
                        totalspace=$((totalspace + size))
                        #FI
                    fi
                fi
                if [ "$d_flag" = 1 ]; then #only d true
                    #IF DATAAAA <<<<<<<<<<<<<<<<<
                    #if [ $arg_date -ge $date ]; then
                    files["${entry}"]=$size
                    totalspace=$((totalspace + size))
                fi
                if [ "$n_flag" = 1 ]; then #only n true
                    if [[ "$entry" = *${nvalue}* ]]; then
                        files["${entry}"]=$size
                        totalspace=$((totalspace + size))
                    fi
                fi
                if (( $d_flag == 0 && $n_flag == 0 )); then
                    files["$entry"]=$size
                    totalspace=$((totalspace + size))
                fi
            fi
        fi
        if [[ -d "${entry}" ]]; then
            dirs[$entry]=$totalspace
            walk $entry
        fi
    done
}

# for entry in $@; do
#     if [[ -d "${entry}" ]]; then
#         root=$entry
#         # echo $root
#         dirs["${root}"]=0;
#     fi
# done

#Call Walk with directories passed on argument
for item in $@; do
    walk "${item}"
done

if [ "$n_flag" = 1 ]; then
    for dir in ${!dirs[@]}; do
        dir_array=("ls -l dir")
        for file in ${!dir_array[@]}; do
            if [ -f file ]; then
                n_array="(print dir_array | sort -nr | head -${nvalue})"
                for f in $n_array; do
                    f_size="$(stat $f | head -2 | tail -1 | awk '{print $2}')"
                    size=$((f_size + size))
                done
            fi
        done
    done
    dirs["${dir}"}]=size    
fi

if [ "$L_flag" = 1 ]; then
    for k in "${!files[@]}"; do
        echo ${files["${k}"]} ${k}
    done | sort -rn -k1 | head -${Lvalue} 
fi

#PRINT ALLF FILES
for item in ${!files[@]}; do
    echo ${files["${item}"]} "${item}"
done
echo "--------------------------"
#PRINT ALL DIRETORIES AND RESPETIVE SIZES
for item in ${!dirs[@]}; do
    echo ${dirs["${item}"]} "${item}"
done

#------------------------------------------------------------------------------------------------------------------
# # -r: por ordem inversa
# function option_r(){
#     echo
#     #   -r, --reverse               reverse the result of comparisons
#     # if [ "$r_flag" = 1 ]; then
#     # declare -a o=()
#     # for i;do
#     # o=("$i" "${o[@]}")
#     # done
#     # printf "%s\n" "${o[@]}"
#     # _-_-_-_-_-_-_-_-_-_-_-_-_-
#     # o=
#     # for i;do
#     # o="$i $o"
#     # done
#     # printf "%s\n" $o
# }

# # -a: por ordem alfabetica
# function option_a(){
#     echo
#     # o Sort sem nenhum argumento faz o sort alfabetico
#     # A=( $(sort <(printf "%s\n" "$@")) )
#     # printf "%s\n" "${A[@]}"
#     # sort the arguments list i.e."$@"`
#     # store output of sort in an array
#     # Print the sorted array
# }