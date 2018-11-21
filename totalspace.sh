#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail

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

#Recursive function to list directories and files
declare -A dirs
declare -A files
walk() {
    # Se e um diretorio chama a walk() ---> recursiva
    for entry in "$1"/*; do
        if [[ -d "${entry}" ]]; then
            dirs[$entry]=0;
            walk $entry
        fi
        #IMPLEMENTAR ALGO DO ESTILO DEPTH-SEARCH PARA IR SABENDO O SIZE DE CADA DIR
        #ls -LRlh
        if [[ -f "$entry" ]]; then
            if [[ -v files[$entry] ]]; then
                dir=${entry##*/}
                # dir="$(dirname "${entry}")"
                size="$(stat $entry | head -2 | tail -1 | awk '{print $2}')"
                old_size=files["$dir"]
                new_size=$((old_size+size))
                files[$dir]=$total_size
            else
                # dir="$(dirname "${entry}")"
                dir=${entry##*/}
                files["$dir"]=0
                size="$(stat $entry | head -2 | tail -1 | awk '{print $2}')"
                files["$dir"]=$size
            fi
        fi
    done
}

#for every input of
for item in $@; do
    walk "${item}"
    # printf "%s\n" "${assoc[@]}"   #Tests
done

#-n expressão regular que é verificada com o nome dos ficheiros//$./totalspace.sh -n “.*sh” sop
if [ "$n_flag" = 1 ]; then
    declare -A n_array
    for i in ${!files[*]}
    do
        # echo "${i}"
        if [[ "$i" = *${nvalue}* ]]; then
            n_array["${i}"]=0
            content=${files["${i}"]}
            n_array["${i}"]=${content}
            echo "${i}"
        fi
    done
#
fi


#-l: indicação de quantos, de entre os maiores ficheiros em cada diretoria, devem ser considerados//$./totalspace.sh -l 2 sop
function option_l(){
    #Fazer aqui um sort
    echo
}

#-d: especificação do data máxima de acesso acesso aos ficheiros//$./totalspace -d "Sep 10 10:00"

#-L: indicação de quantos ficheiros, de entre os maiores em todas as diretorias, devem ser considerados
#Gera 1 linha de saída por cada ficheiro
if [ "$L_flag" = 1 ]; then
    declare -A L_array
    sort -k2 $files
    for i in ${!files[*]}
    do
        # echo "${i}"
        if [[ "$i" = *${nvalue}* ]]; then
            L_array["${i}"]=0
            content=${files["${i}"]}
            L_array["${i}"]=${content}
            echo "${i}"
        fi
    done
#
fi

#-r: por ordem inversa
function option_r(){
    #   -r, --reverse               reverse the result of comparisons
    declare -a o=()
    for i;do
        o=("$i" "${o[@]}")
    done
    printf "%s\n" "${o[@]}"
    #_-_-_-_-_-_-_-_-_-_-_-_-_-
    o=
    for i;do
        o="$i $o"
    done
    printf "%s\n" $o
}

#-a: por ordem alfabetica
function option_a(){
    # o Sort sem nenhum argumento faz o sort alfabetico
    A=( $(sort <(printf "%s\n" "$@")) )
    printf "%s\n" "${A[@]}"
    #sort the arguments list i.e."$@"`
    #store output of sort in an array
    #Print the sorted array
}

# for item in $@; do
#     walk "${item}"
#     # printf "%s\n" "${assoc[@]}"
# done

# for i in "${!assoc[@]}"
# do
# echo "key  : $i"
# echo "value: ${assoc[$i]}"
# done