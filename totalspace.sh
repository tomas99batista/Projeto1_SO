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
    echo
}
#-l: indicação de quantos, de entre os maiores ficheiros em cada diretoria, devem ser considerados//$./totalspace.sh -l 2 sop
function option_l(){
    #Fazer aqui um sort
    echo
}

#-d: especificação do data máxima de acesso acesso aos ficheiros//$./totalspace -d "Sep 10 10:00"
function option_d(){
    echo
}

#-L: indicação de quantos ficheiros, de entre os maiores em todas as diretorias, devem ser considerados
#Gera 1 linha de saída por cada ficheiro
function option_L(){
    echo
}

#-r: por ordem inversa
function option_r(){
    echo
}

#-a: por ordem alfabetica
function option_a(){
    echo
}

myArray=()
count=0
declare -A assoc[$1]=0
# declare last_size=0;

#Function recursiva para listar diretorios
walk() {
    # Se e um diretorio chama a walk() ---> recursiva
    for entry in "$1"/*; do
        if [[ -d "${entry}" ]]; then
            assoc[$entry]=0
            ARRNAME="$entry"
            myArray[count]="$ARRNAME"
            count=$count+1
            walk "$entry";
            # # echo $last_size
        fi
        
        if [[ -f "$entry" ]]; then
            file_specs "$entry";
        fi
    done
}


file_specs() {
    DIR="$(dirname "${entry}")"
    SIZE="$(stat $entry | head -2 | tail -1 | awk '{print $2}')"
    oldSize=${assoc[$DIR]}
    newSize=$[$oldSize+$SIZE]
    assoc["$DIR"]=$newSize
    
    #echo "$SIZE"
    # FILE_NAME="$(basename "${entry}")"
    # NAME="${FILE_NAME%.*}"
    # EXT="${FILE_NAME##*.}"
    # DATE="$(stat $entry | tail -4 | head -1 | cut -d ' ' -f2)"
    # printf "\n%s\n" "${entry}"
    # printf "%s \t %s \t %s\n" "$SIZE" "$NAME" "$DATE"
}

#MAIN
while getopts '::n:f:l:d:L:ra' OPTION; do
    case "$OPTION" in
        n)
            nvalue="$OPTARG"
            
        ;;
        
        l)
            #NAO PODE CONJUGAR COM -L
            lvalue="$OPTARG"
            echo "l c/ arg $OPTARG"
        ;;
        
        d)
            dvalue="$OPTARG"
            echo "d c/ arg $OPTARG"
        ;;
        
        L)
            #NAO PODE CONJUGAR COM -l
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

for item in $@; do
    [[ -z "${item}" ]] && ABS_PATH="${PWD}" || cd "${item}" && ABS_PATH="${PWD}"
    walk "${ABS_PATH}"
    # printf "%s\n" "${assoc[@]}"
done

# for i in "${!assoc[@]}"
# do
    # echo "key  : $i"
    # echo "value: ${assoc[$i]}"
# done
