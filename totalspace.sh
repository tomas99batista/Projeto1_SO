#!/bin/bash
#89296 Tomas Batista
#89236 Joao Dias
#SO Trabalho Pratico 1
set -e
set -u
set -o pipefail

#-------------------------------------------------------------------------------------------------------------------------------------------------------

#-n expressão regular que é verificada com o nome dos ficheiros//$./totalspace.sh -n “.*sh” sop
option_n(){
     declare -A move
    # struct=$1
    # echo "${struct}"
    # echo "${!struct[*]}"
    #^^^^^^^n sei ate q ponto e necessario fazer isto dado que o array que e passado a func esta ja definido
    #inbestigue-se..........................
    for i in ${!files[*]}
    do
        echo "${i}"
        if [[ "$i" = *p* ]]; then
            move["${i}"]=0
            content=${files["${i}"]}
            move["${i}"]=${content}
            echo "${i}"
        fi
    done
    echo "${move[@]}"
}
option_n 

#-l: indicação de quantos, de entre os maiores ficheiros em cada diretoria, devem ser considerados//$./totalspace.sh -l 2 sop
function option_l(){
    #Fazer aqui um sort
    echo
}

#-d: especificação do data máxima de acesso acesso aos ficheiros//$./totalspace -d "Sep 10 10:00"
function option_d(){
    stat totalspace.sh | head -5 | tail -1 | cut -d " " -f2
}

#-L: indicação de quantos ficheiros, de entre os maiores em todas as diretorias, devem ser considerados
#Gera 1 linha de saída por cada ficheiro
function option_L(){
    echo
}

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



#Function recursiva para listar diretorios
declare -A dirs
declare -A files
walk() {
    # Se e um diretorio chama a walk() ---> recursiva
    for entry in "$1"/*; do
        if [[ -d "${entry}" ]]; then
            dirs[$entry]=0;
            walk $entry
        fi
        #IMPLEMENTAR ALGO DO ESTILO BREADTH-FIRST PARA IR SABENDO O SIZE DE CADA DIR
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

for item in $@; do
    walk "${item}"
    
    # printf "%s\n" "${assoc[@]}"
done
# for i in "${!files[@]}"
# do
#     echo "${i} = ${files[$i]}"
# done
# for i in "${!dirs[@]}"
# do
#     echo "${i} = ${dirs[$i]}"
# done

#MAIN
while getopts '::n:f:l:d:L:ra' OPTION; do
    case "$OPTION" in
        n)
            nvalue="$OPTARG"
            
        ;;
        
        l)
            l_flag=1; #fazer if, se as 2 flagas tiverem on da block
            lvalue="$OPTARG"
            echo "l c/ arg $OPTARG"
        ;;
        
        d)
            dvalue="$OPTARG"
            echo "d c/ arg $OPTARG"
        ;;
        
        L)
            L_flag=1
            Lvalue="$OPTARG"
            echo "L c/ arg $OPTARG"
        ;;
        
        r)
            echo "r - reverse"
        ;;
        
        a)
            echo "a - alfabeta"
        ;;
        
        \?)
            echo "$(basename $0) OPTIONS: [-n arg] [-l arg] [-d arg] [-L arg] [-r] [-a]" >&2
            exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"

# for item in $@; do
#     walk "${item}"
#     # printf "%s\n" "${assoc[@]}"
# done

# for i in "${!assoc[@]}"
# do
# echo "key  : $i"
# echo "value: ${assoc[$i]}"
# done
